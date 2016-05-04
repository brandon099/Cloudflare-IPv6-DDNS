#!/bin/sh
# Script that will produce JSON output to help user obtain information needed for cf-ddns.sh
#Credit to http://torb.at/cloudflare-dynamic-dns for script syntax

# 1. Set "tkn" to equal your API key.
# 2. Set "email" to equal your e-mail address
# 3. Set "z" to equal the domain name that the zone record is associated to

curl https://www.cloudflare.com/api_json.html \
  -d 'a=rec_load_all' \
  -d 'tkn=9a7806061c88ada191ed06f989cc3dac' \
  -d 'email=email@example.com' \
  -d 'z=example.com'
