#!/bin/bash

###Installer for cf-ddns.sh###

echo "This script will help you configure a working Cloudflare DDNS script on a Linux machine"
echo -e ' \t '

sleep 2

echo "Please copy and paste your Cloudflare API Key now (found at https://www.cloudflare.com/a/account/my-account > Global API Key)"
read API

echo -e ' \t '

echo "Please enter your Cloudflare user e-mail address."
read email

echo -e ' \t '

echo "Please enter the main zone record (a.k.a. domain name)"
read domain

echo -e ' \t '








echo "Loading JSON output.... The following JSON output will be quite large. Starting with the first bracket and ending with the last, copy the output and place it in a JSON interpreter (http://json.parser.online.fr/). Find the rec id for the A record that you would like to associate with the cf-ddns script."

sleep 16
echo -e ' \t '
echo -e ' \t '
echo -e ' \t '

curl https://www.cloudflare.com/api_json.html \
  -d 'a=rec_load_all' \
  -d tkn=$API \
  -d email=$email \
  -d z=$domain






sleep 15 

echo -e ' \t '
echo -e ' \t '
echo -e ' \t '
read -n1 -r -p "Press space to continue..." key

if [ "$key" = '' ]; then
    echo "Now we will configure the ddns script." 
    sleep 3
    echo "Please enter your rec ID"

    read id
    
    echo -e ' \t '
    echo "Please enter the name of your A record (i.e. "server" in server.example.com)"
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
echo "Permissions for /var/tmp/current_ip.txt are not correct for user executing cf-ddns.sh. Please change the ownership of /var/tmp/current_ip.txt to the user running the DDNS script."
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
