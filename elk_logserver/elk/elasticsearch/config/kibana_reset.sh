kafka_check_path=/usr/share/elasticsearch/config/kibana_password
if [ -f "$kafka_check_path" ]; then
echo "";
exit 1;
fi
if [ $KIBANA_CONNECT_PASSWORD ];then
if [ ! -f "$kafka_check_path" ]; then
/usr/share/elasticsearch/bin/elasticsearch-reset-password  --username kibana -i << EOF
y
$KIBANA_CONNECT_PASSWORD
$KIBANA_CONNECT_PASSWORD
EOF
fi
fi
