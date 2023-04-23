src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=mongod
printHeader "Setup Mongo Repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo
statusCheck $?
printHeader "Install Mongodb"
yum install mongodb-org -y &>>$logfile
statusCheck $?
printHeader "Enable Listen Address to 0.0.0.0"
#Update the listening address to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$logfile
statusCheck $?
funcEnableService
statusCheck $?