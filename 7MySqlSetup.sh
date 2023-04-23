src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=mysqld
printHeader "Disable MySQL 8 Version"
dnf module disable mysql -y &>>$logfile
statusCheck $?
printHeader "Copy MySQL Repo"
cp "$src_path"/mysql.repo /etc/yum.repos.d/ &>>$logfile
printHeader "Install MySQL"
yum install mysql-community-server -y &>>$logfile
statusCheck $?
funcEnableService
printHeader "Set Root User and Password"
mysql_secure_installation --set-root-pass "$mysql_pwd" &>>$logfile
statusCheck $?