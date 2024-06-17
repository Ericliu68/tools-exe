HOME_PATH=$PWD
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/redis-cluster
fi

FILE_NAME="redis-cluster.yml"
# 端口是连续的，并且每个端口+10000是集群的联系端口，也是连续的
PORT=7000
PASSWORD=12345678
# 尽量最小是6， 实际是3的倍数， 9， 12
machines_number=12

TAB="  "
one_tab=" "
bar="-"
colon=":"
echo 'version'$colon' "3.8"' > $FILE_NAME
echo "services$colon" >> $FILE_NAME
for i in `seq 1 $machines_number`
do
    port=`expr $PORT + $i`
    export REDIS_PATH_${i}=$HOME_PATH/redis-${i}
    export REDIS_PORT_${i}=$port

	echo "$TAB""redis"$i":" >> $FILE_NAME
	echo "$TAB$TAB""image: redis:6.0.8" >> $FILE_NAME
	echo "$TAB$TAB""container_name: redis"$i >> $FILE_NAME
	echo "$TAB$TAB""restart: always" >> $FILE_NAME
	echo "$TAB$TAB""environment:" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""TZ=\"Asia/Shanghai\"" >> $FILE_NAME
	echo "$TAB$TAB""volumes:" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""\${REDIS_PATH_"$i"}/conf/redis-""\${REDIS_PORT_"$i"}.conf:/usr/local/etc/redis/redis.conf" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""\${REDIS_PATH_"$i"}/data:/data" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""\${REDIS_PATH_"$i"}/logs:/logs" >> $FILE_NAME
	echo "$TAB$TAB""ports:" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""\${REDIS_PORT_"$i"}:\${REDIS_PORT_"$i"}" >> $FILE_NAME
	echo "$TAB$TAB$TAB$bar$one_tab""1\${REDIS_PORT_"$i"}:1\${REDIS_PORT_"$i"}" >> $FILE_NAME
	echo "$TAB$TAB""command: redis-server /usr/local/etc/redis/redis.conf" >> $FILE_NAME
	echo >> $FILE_NAME
done

ip_list=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d 'addr:' | sed -n '1p'`
local_ip=${ip_list%%/*}
export LOCAL_IP=$local_ip

# redis-cli -a 909090 --cluster create 172.19.0.9:6379 172.19.0.4:6379 172.19.0.7:6379 172.19.0.8:6379 172.19.0.3:6379 172.19.0.2:6379 172.19.0.5:6379 172.19.0.10:6379 172.19.0.6:6379  --cluster-replicas  2
# redis-cli -a 909090 --cluster create redis1:6379 redis2:6379 redis3:6379 redis4:6379 redis5:6379 redis6:6379 redis7:6379 redis8:6379 redis9:6379  --cluster-replicas  2
# redis-cli -a 909090 --cluster create 192.168.0.175:7001 192.168.0.175:7002 192.168.0.175:7003 192.168.0.175:7004 192.168.0.175:7005 192.168.0.175:7006 192.168.0.175:7007 192.168.0.175:7008 192.168.0.175:7009  --cluster-replicas  2
# sudo rm -rf redis-1 redis-2 redis-3 redis-4 redis-5 redis-6 redis-7 redis-8 redis-9
# # echo 'yes' | docker exec -i redis1 redis-cli -a 909090 --cluster create 192.168.0.175:7001 192.168.0.175:7002 192.168.0.175:7003 192.168.0.175:7004 192.168.0.175:7005 192.168.0.175:7006 192.168.0.175:7007 192.168.0.175:7008 192.168.0.175:7009  --cluster-replicas 2
# echo 'yes' | docker exec -i redis1 redis-cli -a 909090 --cluster create 192.168.0.175:7001 192.168.0.175:7002 192.168.0.175:7003 192.168.0.175:7004 192.168.0.175:7005 192.168.0.175:7006  --cluster-replicas 1
# echo 'yes' | docker exec -i redis1 redis-cli -a ${PASSWORD} --cluster create ${LOCAL_IP}:7001 ${LOCAL_IP}:7002 ${LOCAL_IP}:7003 ${LOCAL_IP}:7004 ${LOCAL_IP}:7005 ${LOCAL_IP}:7006 ${LOCAL_IP}:7007 ${LOCAL_IP}:7008 ${LOCAL_IP}:7009  --cluster-replicas 2

if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	# if [ $(whoami) = "root" ]; then
	# 	v=""
	# else
	# 	v="sudo "
	# fi
	echo $local_ip
    v=""
	# 创建目录, (权限要够)
	for i in `seq 1 $machines_number`
	do
		port=`eval echo '$'"REDIS_PORT_$i"`
		path=`eval echo '$'"REDIS_PATH_$i"`
		${v}mkdir -p $path
		${v}mkdir -p $path/data
		${v}mkdir -p $path/conf
		${v}mkdir -p $path/logs
		${v}chmod -R 777 $path
		config_path=$path/conf/redis-${port}.conf
		cat redis.conf | grep -v "#" | grep -v "^$" | sed "s/6379/$port/g" |sed "s/127.0.0.1/0.0.0.0/g" | sed "s/appendonly no/appendonly yes/g" | sed "s/dir .\//dir \/data\//g" | sed "s/logfile \"\"/logfile \"\/logs\/redis.log\"/g" > $config_path
		echo "cluster-enabled yes" >> $config_path
		echo "cluster-config-file nodes-$port.conf" >> $config_path
		echo "cluster-require-full-coverage no" >> $config_path
		echo "cluster-node-timeout 5000" >> $config_path
		echo "requirepass $PASSWORD" >> $config_path
		echo "masterauth $PASSWORD" >> $config_path
	done
	docker-compose -f ${FILE_NAME} up -d
	sleep 10s
	cluster_command="echo 'yes' | docker exec -i redis1 redis-cli -a ${PASSWORD} --cluster create"
	for i in `seq 1 $machines_number`
	do
		port=`eval echo '$'"REDIS_PORT_$i"`
		ip_port=${LOCAL_IP}":"$port
		cluster_command=$cluster_command" "$ip_port
	done
	if [ $machines_number -ge 12 ];	then
		cluster_command=$cluster_command" --cluster-replicas 3"
	elif [ $machines_number -ge 9 ]; then
		cluster_command=$cluster_command" --cluster-replicas 2"
	else
		cluster_command=$cluster_command" --cluster-replicas 1"
	fi
	eval $cluster_command
elif [ "$1" = "config" ]; then
	docker-compose -f ${FILE_NAME} config
elif [ "$1" = "stop" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_NAME} stop "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "down" ]; then
	docker-compose -f ${FILE_NAME} down
elif [ "$1" = "rm" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_NAME} stop "$2"
		docker-compose -f ${FILE_NAME} rm "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "restart" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_NAME} restart "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "ps" ]; then
    docker-compose -f ${FILE_NAME} ps
else
	echo "please enter one of [start, config, stop, down, restart, rm]"
fi


