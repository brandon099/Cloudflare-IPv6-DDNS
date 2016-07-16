#!/bin/bash

###Installer for cf-ddns.sh###

echo "This script will help you configure a working Cloudflare DDNS script on a Linux machine. Please ensure that the programs 'jq' and 'grep' are installed in order for the installer to work"
echo -e ' \t '

sleep 2

echo "Please copy and paste your Cloudflare API Key now (found at https://www.cloudflare.com/a/account/my-account > Global API Key)"
read API

echo -e ' \t '

echo "Please enter your Cloudflare user e-mail address."
read email

echo -e ' \t '

echo "Please enter the domain name associated with your Cloudflare account"
read domain

echo -e ' \t '



echo "Loading Cloudflare information...."
sleep 3
echo -e ' \t '
echo -e ' \t '
echo -e ' \t '

{ curl https://www.cloudflare.com/api_json.html \
  -d 'a=rec_load_all' \
  -d tkn=$API \
  -d email=$email \
  -d z=$domain
} > json.txt

cat json.txt | jq '.' | grep -B 5 '"type": "A".'

sleep 2

echo -e ' \t '
echo -e ' \t '
echo -e ' \t '
echo "Locate the rec_id and zone name of the A record you would like to assign to the DDNS script"
sleep 2
echo -e ' \t '
echo -e ' \t '
read -n1 -r -p "Press space to continue..." key

if [ "$key" = '' ]; then
    echo "Now we will configure the ddns script." 
    sleep 3
    echo "Please enter your rec ID"

    read id
    
    echo -e ' \t '
    echo "Please enter the zone name of your A record (i.e. "server" in server.example.com)"
    read name


 
else
    echo "Goodbye"
    exit
fi

echo '#!/bin/sh

if [ ! -f /var/tmp/current_ip.txt ] && touch /var/tmp/currentip.txt; then 
echo "Running script"
sleep 2

else 
echo
"Error!"
echo -e ' \t '

"If you received a permission denied error that means permissions for /var/tmp/current_ip.txt are not correct for user executing cf-ddns.sh. Please change the ownership of /var/tmp/current_ip.txt to the user running the DDNS script. If you received a different error please reach out to the author at http://www.primal.support/contact."
exit 1
fi 

##Set variable NEWIP to the public IPv4 address of the network that your server is currently connected to##
NEWIP=`dig +short myip.opendns.com @resolver1.opendns.com`


##Set variable CURRENTIP to whatever IPv4 address your domain name is currently pointed to##
CURRENTIP=`getent ahosts $DOMAIN | awk '{print $1}' | head -1`


if [ "$NEWIP" = "$CURRENTIP" ]
then
  echo "IP address unchanged"
else
  curl https://www.cloudflare.com/api_json.html \
    -d 'a=rec_edit' \
    -d 'tkn=$API' \
    -d 'email=$email' \
    -d 'z=$domain' \
    -d 'id=$id' \
    -d 'type=A' \
    -d 'name=$name' \
    -d 'ttl=1' \
    -d "content=$NEWIP"
  echo $NEWIP > /var/tmp/currentip.txt
fi' > cf-ddns.sh


chmod u+x cf-*

echo "Within your directory will now be a functioning cf-ddns.sh script. Execute it by running the following command: ./cf-ddns.sh"
