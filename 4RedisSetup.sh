src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=redis
printHeader "Install Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$logfile
statusCheck $?
printHeader "Install Redis"
dnf module enable redis:remi-6.2 -y &>>$logfile
yum install redis -y &>>$logfile
statusCheck $?
printHeader "Update Redis Listen Address"
#Update listening address to 0.0.0.0 in /etc/redis.conf
sed -i 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$logfile
statusCheck $?
funcEnableService
statusCheck $?
