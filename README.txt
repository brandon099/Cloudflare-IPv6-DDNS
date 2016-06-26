# Cloudflare-DDNS Script
Description: 
Cloudflare dynamic dns script that will update your domain's public IPv4 address to the address that your server is connected to. Compatible with IPv6 enabled modems.

Operating Systems tested on:
CentOS 6.7 32 bit
CentOS 7 64 bit
Ubuntu 14.04 32 bit
Ubuntu Server 15.10 64 bit

Credit belongs primarily to http://torb.at/cloudflare-dynamic-dns as most of the syntax in this DDNS script was derived from script shown on website, with some modifications needed for compatibility for IPv6.




 Five pieces of information will be needed to added to cf-ddns.sh for the script to work. Edit cf-ddns.sh so that the variables at the beginning of the script equal the following information:

1. The zone record that you will be updating (zone.example.com for a subdomain, or just example.com)
2. The email associated with your cloudflare login
3. Your cloudflare API key (found in My Settings > API Key)
4. The Zone ID number of the zone record
5. The domain name that your zone record is associated with (example.com)

To get the zone ID number of the zone record that you will be updating use cf-info.sh script. Download cf-info.sh and execute it on a Linux machine. Place the output of the script in a JSON interpreter (like the one found at http://json.parser.online.fr/) and that will give you the zone records with their associated Zone IDs and other relevant information.




Edit the text of cf-ddns.sh and replace the requested information with the information from the output of the interpreted JSON.

Once the script is configured properly, execute it and it will update the A record of the associated zone to the IP address of the network the computer the script is being run from.

Once confirmed it is working, it can be configured as a cron job to run frequently to avoid any downtime if the public IP address of your modem changes.
