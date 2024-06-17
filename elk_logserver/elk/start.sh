# 基础目录
HOME_PATH=/home/user/elk
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/mysql-pxc
fi
FILE_NAME="docker-compose.yml"
ES_PATH=$HOME_PATH/elasticsearch
KIBANA_PATH=$HOME_PATH/kibana
METRICBEAT_PATH=$HOME_PATH/metricbeat
LOGSTASH_PATH=$HOME_PATH/logstash
LOGSTASH_LOG_PATH=/home/user/PycharmProjects/work
GRAFANA_PATH=$HOME_PATH/grafana
# 存入环境变量
export ES_PATH=$ES_PATH
export KIBANA_PATH=$KIBANA_PATH
export METRICBEAT_PATH=$METRICBEAT_PATH
export LOGSTASH_PATH=$LOGSTASH_PATH
export LOGSTASH_LOG_PATH=$LOGSTASH_LOG_PATH
export GRAFANA_PATH=$GRAFANA_PATH

# es的密码
ES_PASSWORD=909090
# es中kibana账户的密码
KIBANA_PASSWORD=909090
# 存入环境变量
export ES_PASSWORD=$ES_PASSWORD
export KIBANA_PASSWORD=$KIBANA_PASSWORD

ES_PORT_1=9200
ES_PORT_2=9300
KIBANA_PORT=5601
LOGSTASH_HTTP_PORT=8888
LOGSTASH_BEAT_PORT=5086
LOGSTASH_HTTP_FILE_PORT=8889
GRAFANA_HTTP_PORT=3000

REAL_TIME_LOGSTASH="realLogstash"
REAL_TIME_LOGSTASH_PASSWORD="logstash9090"
FILE_LOGSRASH="fileLogstash"
FILE_LOGSRASH_PASSWORD="logstash9090"

export ES_PORT_1=$ES_PORT_1
export ES_PORT_2=$ES_PORT_2
export KIBANA_PORT=$KIBANA_PORT
export LOGSTASH_HTTP_PORT=$LOGSTASH_HTTP_PORT
export LOGSTASH_BEAT_PORT=$LOGSTASH_BEAT_PORT
export LOGSTASH_HTTP_FILE_PORT=$LOGSTASH_HTTP_FILE_PORT
export REAL_TIME_LOGSTASH=${REAL_TIME_LOGSTASH}
export REAL_TIME_LOGSTASH_PASSWORD=${REAL_TIME_LOGSTASH_PASSWORD}
export FILE_LOGSRASH=${FILE_LOGSRASH}
export FILE_LOGSRASH_PASSWORD=${FILE_LOGSRASH_PASSWORD}
export GRAFANA_HTTP_PORT=${GRAFANA_HTTP_PORT}



# jvm 虚拟，生产尽量提升一下，但是不要超过总内存的1/2， 最好是 内存1/2-1
export ES_JAVA_OPTS="-Xms512m -Xmx1g"

if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	if [ $(whoami) = "root" ]; then
		v=""
	else
		v="sudo "
	fi
	# 创建目录, (权限要够)
	${v}mkdir -p $HOME_PATH
	${v}mkdir -p $ES_PATH
	${v}mkdir -p $ES_PATH/data
	${v}mkdir -p $ES_PATH/logs
	${v}mkdir -p $ES_PATH/plugins
	${v}mkdir -p $KIBANA_PATH
	${v}mkdir -p $METRICBEAT_PATH
	${v}mkdir -p $LOGSTASH_PATH
	${v}mkdir -p $LOGSTASH_LOG_PATH
	${v}mkdir -p $GRAFANA_PATH/config

	${v}chmod -R 777 $ES_PATH/data
	${v}chmod -R 777 $ES_PATH/logs
	${v}chmod -R 777 $ES_PATH/plugins

	${v}cp -rf ./elasticsearch/config $ES_PATH/.
	${v}cp -rf ./kibana/config $KIBANA_PATH/.
	${v}cp -rf ./logstash/config $LOGSTASH_PATH/.
	${v}cp -rf ./grafana/config $GRAFANA_PATH/.
	${v}cp -f ./metricbeat/metricbeat.yml $METRICBEAT_PATH/.
	${v}cp -f ./Shanghai $ES_PATH/.
	${v}cp -f ./Shanghai $KIBANA_PATH/.
	${v}cp -f ./Shanghai $LOGSTASH_PATH/.
	${v}cp -f ./Shanghai $METRICBEAT_PATH/.
	# 更改metricabeat配置文件权限，只有root
	${v}chown root:root $METRICBEAT_PATH/metricbeat.yml

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
