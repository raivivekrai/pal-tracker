#!/usr/bin/env bash
set -e


app_guid=`cf app $1 --guid`
credentials=`cf curl /v2/apps/$app_guid/env | jq '.system_env_json.VCAP_SERVICES' | jq '.["cleardb"][0].credentials'`

ip_address=`echo $credentials | jq -r '.hostname'`
db_port=`echo $credentials | jq -r '.port'`
db_name=`echo $credentials | jq -r '.name'`
db_username=`echo $credentials | jq -r '.username'`
db_password=`echo $credentials | jq -r '.password'`

#echo "Opening ssh tunnel to $ip_address"
#cf ssh -N -L 63306:$ip_address:3306 pal-tracker &
#cf_ssh_pid=$!

#echo "Waiting for tunnel"
#sleep 5

flyway -url="jdbc:mysql://$ip_address:$db_port/$db_name" -locations=filesystem:databases/tracker -user=$db_username -password=$db_password migrate

#kill -STOP $cf_ssh_pid
