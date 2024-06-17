HOME_PATH=/data/docker/cluster/mysql-pxc
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/mysql-pxc
fi
export FILE_NAME="mysql-cluster.yml"
PXC_PATH_1=$HOME_PATH/pxc1
PXC_PATH_2=$HOME_PATH/pxc2
PXC_PATH_3=$HOME_PATH/pxc3
PXC_PATH_4=$HOME_PATH/pxc4
PXC_PATH_5=$HOME_PATH/pxc5
PXC_PATH_1_BACKUP=/home/mysql/backup
PXC_PATH_1_LOCAL_BACKUP=$HOME_PATH/backup/pxc1
PXC_PATH_2_LOCAL_BACKUP=$HOME_PATH/backup/pxc2

PXC_PORT_1=9001
PXC_PORT_2=9002
PXC_PORT_3=9003
PXC_PORT_4=9004
PXC_PORT_5=9005

# 密码
MYSQL_ROOT_PASSWORD=12345678
XTRABACKUP_PASSWORD=12345678

export HOME_PATH=$HOME_PATH
export PXC_PATH_1_LOCAL_BACKUP=$PXC_PATH_1_LOCAL_BACKUP
export PXC_PATH_2_LOCAL_BACKUP=$PXC_PATH_2_LOCAL_BACKUP
export PXC_PATH_1=$PXC_PATH_1
export PXC_PATH_1_BACKUP=$PXC_PATH_1_BACKUP
export PXC_PATH_2=$PXC_PATH_2
export PXC_PATH_3=$PXC_PATH_3
export PXC_PATH_4=$PXC_PATH_4
export PXC_PATH_5=$PXC_PATH_5
export PXC_PORT_1=$PXC_PORT_1
export PXC_PORT_2=$PXC_PORT_2
export PXC_PORT_3=$PXC_PORT_3
export PXC_PORT_4=$PXC_PORT_4
export PXC_PORT_5=$PXC_PORT_5
export MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
export XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD

if [ "$1" = "start" ]; then
  # 开始复制文件，此处复制文件需要sudo
	if [ $(whoami) = "root" ]; then
		v=""
	else
		v="sudo "
	fi
	# 创建目录, (权限要够)
	${v}mkdir -p $HOME_PATH
    ${v}mkdir -p $PXC_PATH_1
    ${v}mkdir -p $PXC_PATH_1_BACKUP
    ${v}mkdir -p $PXC_PATH_1_LOCAL_BACKUP
    ${v}mkdir -p $PXC_PATH_2_LOCAL_BACKUP
    ${v}mkdir -p $PXC_PATH_2
    ${v}mkdir -p $PXC_PATH_3
    ${v}mkdir -p $PXC_PATH_4
    ${v}mkdir -p $PXC_PATH_5
	${v}chmod -R 777 $PXC_PATH_1
	${v}chmod -R 777 $PXC_PATH_1_BACKUP
	${v}chmod -R 777 $PXC_PATH_1_LOCAL_BACKUP
	${v}chmod -R 777 $PXC_PATH_2_LOCAL_BACKUP
	${v}chmod -R 777 $PXC_PATH_2
	${v}chmod -R 777 $PXC_PATH_3
	${v}chmod -R 777 $PXC_PATH_4
	${v}chmod -R 777 $PXC_PATH_5

	docker-compose -f  ${FILE_NAME} up -d mysql-master-1
    sleep 60
	docker-compose -f  ${FILE_NAME} up -d mysql-master-2 mysql-master-3 mysql-master-4 mysql-master-5
    sleep 20
    # ${v}sed -i '/safe_to_bootstrap: 0/c\safe_to_bootstrap: 1' $PXC_PATH_1/grastate.dat
    # ${v}sed -i '/safe_to_bootstrap: 0/c\safe_to_bootstrap: 1' $PXC_PATH_2/grastate.dat
    # ${v}sed -i '/safe_to_bootstrap: 0/c\safe_to_bootstrap: 1' $PXC_PATH_3/grastate.dat
    # ${v}sed -i '/safe_to_bootstrap: 0/c\safe_to_bootstrap: 1' $PXC_PATH_4/grastate.dat
    # ${v}sed -i '/safe_to_bootstrap: 0/c\safe_to_bootstrap: 1' $PXC_PATH_5/grastate.dat
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


