#!/bin/sh
BP_URI="http://staging.janrainbackplane.com/v1.2/bus"
BP_BUS_NAME=qa-auto-bus
BP_USERNAME=qa-auto-user
BP_PASSWORD=qa-auto-password
BP_CHANNEL=$1

echo curl -u "$BP_USERNAME:$BP_PASSWORD" $BP_URI/$BP_BUS_NAME/channel/$BP_CHANNEL
curl -u "$BP_USERNAME:$BP_PASSWORD" $BP_URI/$BP_BUS_NAME/channel/$BP_CHANNEL
echo ""
