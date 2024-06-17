export HOME_PATH=/data/docker/mysql 
if [ -n "$ROOT_PATH" ]; then
    echo $ROOT_PATH
    HOME_PATH=$ROOT_PATH/mysql
fi
export passwd=12345678
mkdir -p $HOME_PATH
mkdir -p $HOME_PATH/conf
mkdir -p $HOME_PATH/log
mkdir -p $HOME_PATH/data
cp my.cnf $HOME_PATH/conf
#docker run --restart=always -it -p 3306:3306 --name mysql -v $HOME_PATH/conf:/etc/mysql -v $HOME_PATH/log:/var/log/mysql -v $HOME_PATH/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$passwd -d mysql:5.7
docker run --restart=always -it -p 3306:3306 --name mysql -v $HOME_PATH/conf/my.cnf:/etc/my.cnf -v $HOME_PATH/log:/var/log/mysql -v $HOME_PATH/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$passwd -d mysql:5.7
