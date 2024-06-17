HOME_PATH=/home/user/gitfile/kafka-cluster
FILE_YAML="kafka-cluster.yaml"
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/kafka-cluster
fi
echo $HOME_PATH
ZOOKEEPER_PATH_1=$HOME_PATH/zookeeper1
ZOOKEEPER_PATH_2=$HOME_PATH/zookeeper2
ZOOKEEPER_PATH_3=$HOME_PATH/zookeeper3
KAFKA_PATH_1=$HOME_PATH/kafka1
KAFKA_PATH_2=$HOME_PATH/kafka2
KAFKA_PATH_3=$HOME_PATH/kafka3

ZOOKEEPER_PORT_1=12181
ZOOKEEPER_PORT_2=12182
ZOOKEEPER_PORT_3=12183
KAFKA_PORT_1=19091
KAFKA_PORT_2=19092
KAFKA_PORT_3=19093

export HOME_PATH=$HOME_PATH
export ZOOKEEPER_PATH_1=$ZOOKEEPER_PATH_1
export ZOOKEEPER_PATH_2=$ZOOKEEPER_PATH_2
export ZOOKEEPER_PATH_3=$ZOOKEEPER_PATH_3
export KAFKA_PATH_1=$KAFKA_PATH_1
export KAFKA_PATH_2=$KAFKA_PATH_2
export KAFKA_PATH_3=$KAFKA_PATH_3

export ZOOKEEPER_PORT_1=$ZOOKEEPER_PORT_1
export ZOOKEEPER_PORT_2=$ZOOKEEPER_PORT_2
export ZOOKEEPER_PORT_3=$ZOOKEEPER_PORT_3
export KAFKA_PORT_1=$KAFKA_PORT_1
export KAFKA_PORT_2=$KAFKA_PORT_2
export KAFKA_PORT_3=$KAFKA_PORT_3



if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	# if [ $(whoami) = "root" ]; then
	# 	v=""
	# else
	# 	v="sudo "
	# fi
    v=""
	# 创建目录, (权限要够)
	${v}mkdir -p $HOME_PATH
    ${v}mkdir -p $ZOOKEEPER_PATH_1 $ZOOKEEPER_PATH_2 $ZOOKEEPER_PATH_3 $KAFKA_PATH_1 $KAFKA_PATH_2 $KAFKA_PATH_3
    ${v}mkdir -p $ZOOKEEPER_PATH_1/data $ZOOKEEPER_PATH_1/datalog $ZOOKEEPER_PATH_1/logs $ZOOKEEPER_PATH_1/conf
    ${v}mkdir -p $ZOOKEEPER_PATH_2/data $ZOOKEEPER_PATH_2/datalog $ZOOKEEPER_PATH_2/logs $ZOOKEEPER_PATH_2/conf
    ${v}mkdir -p $ZOOKEEPER_PATH_3/data $ZOOKEEPER_PATH_3/datalog $ZOOKEEPER_PATH_3/logs $ZOOKEEPER_PATH_3/conf
    ${v}cp -rf ori_conf/conf/* $ZOOKEEPER_PATH_1/conf/.
    ${v}cp -rf ori_conf/conf/* $ZOOKEEPER_PATH_2/conf/.
    ${v}cp -rf ori_conf/conf/* $ZOOKEEPER_PATH_3/conf/.
    ${v}mkdir -p $KAFKA_PATH_1/data $KAFKA_PATH_2/data $KAFKA_PATH_3/data

	docker-compose -f  ${FILE_YAML} up -d
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


