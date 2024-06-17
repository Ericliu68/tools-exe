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
