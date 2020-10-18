#!/bin/bash

#create temporary file
temp=$(mktemp)

#run iperf3 and save output in json format to temp file
iperf3 -c $1 -J > $temp

 ##cat ./iperf.json > $temp

#get senders field from json file
SENDERS_BPS=$(cat $temp | python3 -c "import sys, json; print(json.load(sys.stdin)['end']['streams'][0]['sender']['bits_per_second'])")

#get receiver field from json file
RECEIVER_BPS=$(cat $temp | python3 -c "import sys, json; print(json.load(sys.stdin)['end']['streams'][0]['receiver']['bits_per_second'])")

#push data to influxdb in database - iperf and mesarement - bitrate 
curl -i -XPOST 'http://localhost:8086/write?db=iperf' --data-binary "bitrate senders_bps=$SENDERS_BPS
bitrate receiver_bps=$RECEIVER_BPS"

#delete temp file
rm ${temp}

exit 0
 ##echo $SENDERS_BPS
 ##echo $RECEIVER_BPS
