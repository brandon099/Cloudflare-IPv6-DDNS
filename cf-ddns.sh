#!/bin/sh

[ ! -f /var/tmp/current_ip.txt ] && touch /var/tmp/currentip.txt



##Assign needed information to these variables##

ZONE="yourdomain.example.com"
EMAIL="youremail@example.com"
APIKEY="your cloudflare api key"
ZONEID="your zone ID for your domain"
DOMAINNAME="yourdomainname.example.com"



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
    -d "tkn=$APIKEY" \
    -d "email=$EMAIL" \
    -d "z=$ZONE" \
    -d "id=$ZONEID" \
    -d 'type=A' \
    -d "name=$DOMAINNAME" \
    -d 'ttl=1' \
    -d "content=$NEWIP"
  echo $NEWIP > /var/tmp/currentip.txt
fi
