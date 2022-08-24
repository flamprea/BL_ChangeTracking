#!/bin/nsh

TIME=$1
SERVER=$2
echo "Sleeping for $TIME seconds on $SERVER"
sleep $TIME
echo "Done"