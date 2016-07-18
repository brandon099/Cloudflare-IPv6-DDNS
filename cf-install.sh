#!/usr/bin/env sh
###Installer for cf-ddns.sh###

# Output formatting
info() { echo -e "\e[34m$@\e[0m"; }
warning() { echo -e "\e[33m$@\e[0m"; }
error() { echo -e "\e[31m$@\e[0m"; }

# Do not want to run as root user
test "$UID" -gt 0 || { error "This script cannot be run as root."; exit;}

# Check if dependencies are met before running
DEPS=(jq grep)
for i in $DEPS; do
  command -v $i >/dev/null 2>&1 || { error >&2 "Please install $i first"; exit 1; }
done

info "This script will help you configure a working Cloudflare DDNS script for a Linux machine.\n"
info "Please enter your Cloudflare API Key:"
read API_KEY

info "Please enter your Cloudflare user e-mail address:"
read EMAIL

info "Please enter the domain name associated with your Cloudflare account:"
read DOMAIN

info "Loading Cloudflare information"
curl https://www.cloudflare.com/api_json.html \
  -d'a=rec_load_all'\
  -d tkn=$API_KEY \
  -d =$EMAIL \
  -d z=$DOMAIN \
  | jq '.'| grep -B 5 '"type": "A".'

info "Locate the rec_id and zone name of the A record you would like to assign to the DDNS script."
read -n1 -r -p "Press space to continue..." SPACE_KEY

if [ "$SPACE_KEY" = '' ]; then
    info "Now we will configure the ddns script."
    info "Please enter your rec ID:"
    read REC_ID

    info "Please enter the zone name of your A record (i.e. 'server' in server.example.com)"
    read $ZONE_NAME
else
    info "Exiting script"
    exit
fi

# Generate cf-ddns.sh script in the current directory
info "Generating cf-ddns.sh"

cat << EOF > ./cf-ddns.sh
#!/usr/bin/env sh

CURR_IP_FILE=/var/tmp/current_ip.txt

# Try to write to the current IP address file, and exit if it cannot
( [ -e "\$CURR_IP_FILE" ] || touch "\$CURR_IP_FILE" ) && [ ! -w "\$CURR_IP_FILE" ] && error "Cannot write to $CURR_IP_FILE" && exit 1

# Set NEWIP to the public IPv4 address of the network that your server is currently connected to
NEWIP=\$(dig +short myip.opendns.com @resolver1.opendns.com)

# Set CURRENTIP to whatever IPv4 address your domain name is currently pointed to
CURRENTIP=\$(getent ahosts $DOMAIN | awk '{print \$1}' | head -1)

# Compare IP addresses to see if anything has changed, and update CloudFlare if it has
if [ "\$NEWIP" = "\$CURRENTIP" ]; then
  echo "IP address unchanged"
else
  echo "IP address has changed, updating CloudFlare..."

  curl https://www.cloudflare.com/api_json.html \\
    -d 'a=rec_edit'\\
    -d 'tkn=$API_KEY'\\
    -d '=$EMAIL'\\
    -d 'z=$DOMAIN'\\
    -d 'id=$REC_ID'\\
    -d 'type=A'\\
    -d 'name=$ZONE_NAME'\\
    -d 'ttl=1'\\
    -d "content=\$NEWIP"

  # Update the tracked IP address
  echo \$NEWIP > \$CURR_IP_FILE
fi
EOF

info "Adding executable bit on cf-ddns.sh script"
chmod u+x cf-*

info "Within this directory will now be a fully configured cf-ddns.sh script. Execute it by running the following command: ./cf-ddns.sh"
