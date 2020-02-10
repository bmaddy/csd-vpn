#!/bin/bash

echo "$0""$@"
env | grep CSD | sort | sed -e "s/^/ENV: /"

# location is usually "Default"
location=$(wget -O - -q "https://$CSD_HOSTNAME/CACHE/sdesktop/data.xml?reusebrowser=1" | grep 'location name=' | head -1 | sed -e 's/.*"\(.*\)".*/\1/')

POST_DATA=$(mktemp)
CURL_CMD=$(mktemp)

agent="AnyConnect Linux"
plat=linux-x86_64
ver=4.2.03013

cat > $POST_DATA <<-END
endpoint.policy.location="Default";
endpoint.enforce="success";
endpoint.fw["IPTablesFW"]={};
endpoint.fw["IPTablesFW"].exists="true";
endpoint.fw["IPTablesFW"].enabled="ok";
endpoint.as["ClamAS"]={};
endpoint.as["ClamAS"].exists="true";
endpoint.as["ClamAS"].activescan="ok";
endpoint.av["ClamAV"]={};
endpoint.av["ClamAV"].exists="true";
endpoint.av["ClamAV"].activescan="ok";
END

cat > $CURL_CMD <<-END
curl \\
	--insecure \\
	--user-agent "$agent $ver" \\
	--header "X-Transcend-Version: 1" \\
	--header "X-Aggregate-Auth: 1" \\
	--header "X-AnyConnect-Platform: $plat" \\
	--cookie "sdesktop=$CSD_TOKEN" \\
	--data-ascii $POST_DATA \\
	"https://$CSD_HOSTNAME/+CSCOE+/sdesktop/scan.xml?reusebrowser=1"
END

cat $CURL_CMD | sed -e "s/^/CURL: /"
cat $POST_DATA | sed -e "s/^/POST: /"

. $CURL_CMD

echo "curl exited with $?"
