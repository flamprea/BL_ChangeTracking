#!/bin/nsh

SERVER_LIST=$@
echo "Setting CW_ACTIVE 'true' on"
echo $SERVER_LIST

echo "Initializing BLCLI"
blcli_connect

for SERVER in ${SERVER_LIST[@]}
do
echo "Processing $SERVER"
blcli_execute Server setPropertyValueByName $SERVER CW_ACTIVE true
echo ""
done

echo "Tearing down session"
blcli_destroy
echo ""
