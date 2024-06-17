mkdir -p $PXC_PATH_1_BACKUP/backup 
shopt -s extglob
mv -f !($PXC_PATH_1_BACKUP/backup) $PXC_PATH_1_BACKUP/backup
shopt -u extglob
innobackupex --user=root --password=${MYSQL_ROOT_PASSWORD} --no-timestamp $PXC_PATH_1_BACKUP
rm -rf $PXC_PATH_1_BACKUP/backup/*
