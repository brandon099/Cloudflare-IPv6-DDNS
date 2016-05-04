# Cloudflare-IPv6-DDNS
Description:
Cloudflare dynamic dns script that will update your domain's public IPv4 address to the address that your server is connected to. Compatible with IPv6 enabled routers.

Operating Systems tested on:
CentOS 6.7 32 bit
CentOS 7 64 bit
Ubuntu 14.04 32 bit
Ubuntu Server 15.10 64 bit

Credit belongs primarily to http://torb.at/cloudflare-dynamic-dns as most of the syntax in this DDNS script was derived from script shown on website.

You will need to input three pieces of information into cf-ddns.sh for the script to work:

1. The zone record that you will be updating (zone.example.com for a subdomain, or just example.com)
2. The email associated with your cloudflare login
3. Your cloudflare API key (found in My Settings > API Key)
4. The zone ID number of the domain
5. The domain name that your zone record is associated with (example.com)



To get the zone ID number of the zone record that you will be updating use this script:

curl https://www.cloudflare.com/api_json.html \
  -d 'a=rec_load_all' \
  -d 'tkn=9a7806061c88ada191ed06f989cc3dac' \
  -d 'email=email@example.com' \
  -d 'z=example.com'


