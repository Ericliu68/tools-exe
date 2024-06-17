### 后端练习使用的常见工具搭建
通过docker搭建工具

#### 1. 安装docker，docker-compose

#### 2. 可以通过根路径下面的`start.sh`直接启动, 或者分开启动
```bash
# 存放docker映射文件的根路径，根据自己要求更改
export ROOT_PATH=/data/docker/cluster
cluster_path=$PWD
cd ./elk_logserver/elk-cluster
sh start.sh start
cd $cluster_path
cd ./kafka-cluster/kafka-password
sh start.sh start
cd $cluster_path
cd ./mysql-pxc
sh pxc-start.sh start
cd $cluster_path
cd ./redis-cluster
sh start.sh start
```
#### 3. 更改密码, 其他配置

```bash
# 存放数据的根路径
export ROOT_PATH=/data/docker/cluster
# 下层启动文件的路径
HOME_PATH=$PWD

# redis， 进入redis文件夹，start.sh
# 端口是连续的，并且每个端口+10000是集群的联系端口，也是连续的
PORT=7000
PASSWORD=12345678
# 尽量最小是6， 实际是3的倍数， 9， 12
machines_number=12


# mysql, mysql-pxc/start_simple_mysql.sh， 单机
export HOME_PATH=/data/docker/mysql 
export passwd=12345678
# mysql, mysql-pxc/pxc-start.sh， pac模式的mysql
PXC_PORT_1=9001
PXC_PORT_2=9002
PXC_PORT_3=9003
PXC_PORT_4=9004
PXC_PORT_5=9005
MYSQL_ROOT_PASSWORD=12345678
XTRABACKUP_PASSWORD=12345678


# kafka，kafka-cluster/kafka-password/start.sh
export PASSWORD="90909090"


# elk， elk_logserver/elk-cluster/start.sh
# 集群密码必须保持一致
ES_PASSWORD=909090
# es中kibana账户的密码
KIBANA_PASSWORD=909090
LOGSTASH_LOG_PATH=/data/log
```

#### 4. 仅作为个人练习时使用搭建