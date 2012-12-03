#!/bin/sh
# add/update user
curl -i --data @user_update.txt -H "Content-type: application/json" http://staging.janrainbackplane.com/v1/provision/user/update
# add the user to the bus
curl -i --data @bus_update.txt -H "Content-type: application/json" http://staging.janrainbackplane.com/v1/provision/bus/update
# now run a couple of quick tests
post-backplane-msg.sh
get-all-bus-msgs.sh 
