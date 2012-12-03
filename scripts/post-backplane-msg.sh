#!/bin/sh
BP_URI="http://staging.janrainbackplane.com/v1.2/bus"
BP_BUS_NAME=qa-auto-bus
BP_USERNAME=qa-auto-user
BP_PASSWORD=qa-auto-password
BP_CHANNEL=`openssl rand -hex 16`
BP_ISO8601_DATE=`date +"%Y-%m-%dT%H:%M:%SZ"`

#RAND_FILENAME=/tmp/$$.$RANDOM.tmp

BP_MESSAGE="[{ \"id\" : \"$BP_ISO8601_DATE\", \"channel_name\" : \"$BP_CHANNEL\", \"bus\" : \"$BP_BUS_NAME\", \"source\" : \"http://localhost/\", \"type\" : \"example/test\", \"sticky\" : false, \"payload\" : { \"msg\": \"hello, world!\" }}]"
echo "$BP_MESSAGE"
curl -i -H "Content-type: application/json" -d "$BP_MESSAGE" -u "$BP_USERNAME:$BP_PASSWORD" $BP_URI/$BP_BUS_NAME/channel/$BP_CHANNEL

echo ""
#now see if that message is there
curl -i $BP_URI/$BP_BUS_NAME/channel/$BP_CHANNEL
echo ""
