#!/bin/bash
# This file is used for testing the and verifiying 
# if the line secret_key line in the settings.yml 
# file is being commented out 

mkdir -p ~/Documents/searxng/testing

# Download the setting.yml file from searxng
curl -o ~/Documents/searxng/testing/settings.yml https://raw.githubusercontent.com/searxng/searxng/refs/heads/master/searx/settings.yml

# Copy setting.yml file
cp ~/Documents/searxng/testing/settings.yml ~/Documents/searxng/testing/settings_copy.yml

# Comment the secret_key line in the settings.yml file
sed -i 's/secret_key: "ultrasecretkey"  # Is overwritten by ${SEARXNG_SECRET}/# &/' ~/Documents/searxng/testing/settings.yml

# See the difference
diff ~/Documents/searxng/testing/settings.yml ~/Documents/searxng/testing/settings_copy.yml