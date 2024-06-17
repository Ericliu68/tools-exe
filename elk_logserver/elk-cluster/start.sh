# 基础目录
HOME_PATH=/data/docker/cluster/elk
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/elk
fi
FILE_NAME="docker-compose.yml"
ES01_PATH=$HOME_PATH/elasticsearch01
ES02_PATH=$HOME_PATH/elasticsearch02
ES03_PATH=$HOME_PATH/elasticsearch03
KIBANA_PATH=$HOME_PATH/kibana
METRICBEAT_PATH=$HOME_PATH/metricbeat
LOGSTASH_PATH=$HOME_PATH/logstash
LOGSTASH_LOG_PATH=/data/log
GRAFANA_PATH=$HOME_PATH/grafana
# 存入环境变量
# 集群信息不能挡在同一个目录下
export ES01_PATH=$ES01_PATH
export ES02_PATH=$ES02_PATH
export ES03_PATH=$ES03_PATH
export KIBANA_PATH=$KIBANA_PATH
export METRICBEAT_PATH=$METRICBEAT_PATH
export LOGSTASH_PATH=$LOGSTASH_PATH
export LOGSTASH_LOG_PATH=$LOGSTASH_LOG_PATH
export GRAFANA_PATH=$GRAFANA_PATH

# es的密码
# 集群密码必须保持一致
ES_PASSWORD=909090
# es中kibana账户的密码
KIBANA_PASSWORD=909090
# 存入环境变量
export ES_PASSWORD=$ES_PASSWORD
export KIBANA_PASSWORD=$KIBANA_PASSWORD

# 端口
ES01_PORT_1=9200
ES02_PORT_1=9201
ES03_PORT_1=9202
ES01_PORT_2=9300
ES02_PORT_2=9301
ES03_PORT_2=9302

KIBANA_PORT=5601
LOGSTASH_HTTP_PORT=8888
LOGSTASH_BEAT_PORT=5086
LOGSTASH_HTTP_FILE_PORT=8889
GRAFANA_HTTP_PORT=3000

REAL_TIME_LOGSTASH="realLogstash"
REAL_TIME_LOGSTASH_PASSWORD="logstash9090"
FILE_LOGSRASH="fileLogstash"
FILE_LOGSRASH_PASSWORD="logstash9090"

export ES01_PORT_1=$ES01_PORT_1
export ES02_PORT_1=$ES02_PORT_1
export ES03_PORT_1=$ES03_PORT_1
export ES01_PORT_2=$ES01_PORT_2
export ES02_PORT_2=$ES02_PORT_2
export ES03_PORT_2=$ES03_PORT_2

export KIBANA_PORT=$KIBANA_PORT
export LOGSTASH_HTTP_PORT=$LOGSTASH_HTTP_PORT
export LOGSTASH_BEAT_PORT=$LOGSTASH_BEAT_PORT
export LOGSTASH_HTTP_FILE_PORT=$LOGSTASH_HTTP_FILE_PORT
export REAL_TIME_LOGSTASH=${REAL_TIME_LOGSTASH}
export REAL_TIME_LOGSTASH_PASSWORD=${REAL_TIME_LOGSTASH_PASSWORD}
export FILE_LOGSRASH=${FILE_LOGSRASH}
export FILE_LOGSRASH_PASSWORD=${FILE_LOGSRASH_PASSWORD}
export GRAFANA_HTTP_PORT=${GRAFANA_HTTP_PORT}

export ES_JAVA_OPTS="-Xms1g -Xmx1g"

if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	if [ $(whoami) = "root" ]; then
		v=""
	else
		v=""
	fi
	# 创建目录, (权限要够)
	${v}mkdir -p $HOME_PATH

	${v}mkdir -p $ES01_PATH
	${v}mkdir -p $ES01_PATH/data
	${v}mkdir -p $ES01_PATH/logs
	${v}mkdir -p $ES01_PATH/plugins

	${v}mkdir -p $ES02_PATH
	${v}mkdir -p $ES02_PATH/data
	${v}mkdir -p $ES02_PATH/logs
	${v}mkdir -p $ES02_PATH/plugins

	${v}mkdir -p $ES03_PATH
	${v}mkdir -p $ES03_PATH/data
	${v}mkdir -p $ES03_PATH/logs
	${v}mkdir -p $ES03_PATH/plugins

	${v}mkdir -p $KIBANA_PATH
	${v}mkdir -p $GRAFANA_PATH/config

	${v}chmod -R 777 $ES01_PATH/data
	${v}chmod -R 777 $ES01_PATH/logs
	${v}chmod -R 777 $ES01_PATH/plugins
	# 和单机一样
	${v}chmod -R 777 $ES02_PATH/data
	${v}chmod -R 777 $ES02_PATH/logs
	${v}chmod -R 777 $ES02_PATH/plugins

	${v}chmod -R 777 $ES03_PATH/data
	${v}chmod -R 777 $ES03_PATH/logs
	${v}chmod -R 777 $ES03_PATH/plugins

	# 集群的ml配置不同，目录文件也不同
	${v}cp -rf ./elasticsearch/config $ES01_PATH/.
	${v}cp -rf ./elasticsearch/config $ES02_PATH/.
	${v}cp -rf ./elasticsearch/config $ES03_PATH/.

	${v}cp -rf ./kibana/config $KIBANA_PATH/.
	${v}cp -rf ./grafana/config $GRAFANA_PATH/.

	${v}cp -f ./Shanghai $ES01_PATH/.
	${v}cp -f ./Shanghai $ES02_PATH/.
	${v}cp -f ./Shanghai $ES03_PATH/.

	${v}cp -f ./Shanghai $KIBANA_PATH/.

	docker-compose -f ${FILE_NAME} up -d
elif [ "$1" = "config" ]; then
	docker-compose config
elif [ "$1" = "stop" ]; then
	if [ "$2" != "" ]; then
		docker-compose stop "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "down" ]; then
	docker-compose down
elif [ "$1" = "rm" ]; then
	if [ "$2" != "" ]; then
		docker-compose stop "$2"
		docker-compose rm "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "restart" ]; then
	if [ "$2" != "" ]; then
		docker-compose restart "$2"
	else
		echo "please enter one service"
	fi
elif [ "$1" = "ps" ]; then
    docker-compose ps
else
	echo "please enter one of [start, config, stop, down, restart, rm]"
fi
