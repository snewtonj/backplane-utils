BP_URI="http://staging.janrainbackplane.com/v1/bus"
BP_BUS_NAME=qa-auto-bus
BP_USERNAME=qa-auto-user
BP_PASSWORD=qa-auto-password
curl -i -u "$BP_USERNAME:$BP_PASSWORD" $BP_URI/$BP_BUS_NAME/
echo ""
