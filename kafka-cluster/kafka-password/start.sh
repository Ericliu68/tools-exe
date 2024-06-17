HOME_PATH=/data/docker/cluster/kafka-cluster
FILE_NAME="kafka-password.yml"
FILE_YAML=$FILE_NAME
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/kafka-cluster
fi
echo $HOME_PATH
ZOOKEEPER_PATH_1=$HOME_PATH/zookeeper
KAFKA_PATH_1=$HOME_PATH/kafka

ZOOKEEPER_PORT_1=12181
KAFKA_PORT_1=19092

export HOME_PATH=$HOME_PATH
export ZOOKEEPER_PATH_1=$ZOOKEEPER_PATH_1
export KAFKA_PATH_1=$KAFKA_PATH_1

export ZOOKEEPER_PORT_1=$ZOOKEEPER_PORT_1
export KAFKA_PORT_1=$KAFKA_PORT_1

export PASSWORD="90909090"

ip_list=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d 'addr:' | sed -n '1p'`
local_ip=${ip_list%%/*}
export LOCAL_IP=$local_ip


if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	# if [ $(whoami) = "root" ]; then
	# 	v=""
	# else
	# 	v="sudo "
	# fi
    v=""
	# 创建目录, (权限要够)
	echo $local_ip

	${v}mkdir -p $HOME_PATH
	${v}mkdir -p $ZOOKEEPER_PATH_1
	${v}mkdir -p $KAFKA_PATH_1
	${v}cp -r ../conf/zookeeper/* $ZOOKEEPER_PATH_1/.
	${v}cp -r ../conf/kafka/* $KAFKA_PATH_1/.
	KAFDROP_BASE64=`/usr/bin/python base.py`
	export KAFDROP_BASE64=$KAFDROP_BASE64
	echo $KAFDROP_BASE64
	docker-compose -f ${FILE_YAML} up -d
elif [ "$1" = "config" ]; then
	docker-compose -f ${FILE_YAML} config
elif [ "$1" = "stop" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_YAML} stop "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "down" ]; then
	docker-compose -f ${FILE_YAML} down
elif [ "$1" = "rm" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_YAML} stop "$2"
		docker-compose -f ${FILE_YAML} rm "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "restart" ]; then
	if [ "$2" != "" ]; then
		docker-compose -f ${FILE_YAML} restart "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "ps" ]; then
    docker-compose -f ${FILE_YAML} ps
else
	echo "please enter one of [start, config, stop, down, restart, rm]"
fi


