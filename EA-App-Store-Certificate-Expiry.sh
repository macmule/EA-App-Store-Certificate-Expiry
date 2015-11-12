#!/bin/bash
####################################################################################################
#
# More information: https://macmule.com/2015/11/12/some-mac-app-store-apps-damaged-prompting-for-redownload/
#
# GitRepo: https://github.com/macmule/EA-App-Store-Certificate-Expiry
#
# License: https://macmule.com/license/
#
####################################################################################################

# List all Applications in /Applications
applicationsList="$(ls -d /Applications/*.app)"

# For each app in Applications...
for app in $applicationsList;
do
	# Check to see if the .app bundle has a receipt
	if [ -f "$app"/Contents/_MASReceipt/receipt ]; then
		# Return App Store Certificate expiration
		firstCertExpiry=$(openssl pkcs7 -inform der -in "$app"/Contents/_MASReceipt/receipt -print_certs -text | awk -F ' : ' '/Not After :/ { print $2; exit }')
		# Add the above to an array
		appArray+=("$app" : "$firstCertExpiry" "\n")
	fi
done

# Echo out for Extension Attribute
echo -e "<result>${appArray[*]}</result>"
