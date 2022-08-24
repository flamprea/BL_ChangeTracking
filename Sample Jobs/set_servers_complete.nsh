#!/bin/nsh

SERVER_LIST=$@
echo "Setting CW_COMPLETE 'true' on"
echo $SERVER_LIST

echo "Sleeping for 2 minutes to allow any remaining changes to apply"
sleep 120

echo "Initializing BLCLI"
blcli_connect

for SERVER in ${SERVER_LIST[@]}
do
echo "Processing $SERVER"
blcli_execute Server setPropertyValueByName $SERVER CW_COMPLETE true
echo ""
done

echo "Tearing down session"
blcli_destroy

