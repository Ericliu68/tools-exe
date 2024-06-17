kafka_check_path=/usr/share/elasticsearch/config/kibana_password
v=$(sh ./config/kibana_reset.sh)
result=$(echo $v|grep "successfully")
if [ -z "$v" ]; then
  echo ""
elif [[ "$result" != "" ]]; then
  touch $kafka_check_path;
else
  rm -f /usr/share/elasticsearch/config/kibana_password
fi



