src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=rabbitmq-server
printHeader "Setup Erlang Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$logfile
statusCheck $?
printHeader "Install Erlang"
yum install erlang -y &>>$logfile
statusCheck $?
printHeader "Setup RabbitMQ Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$logfile
statusCheck $?
printHeader "Install RabbitMQ Server"
yum install rabbitmq-server -y &>>$logfile
statusCheck $?
funcEnableService
printHeader "Setup RabbitMQ User and Password"
rabbitmqctl add_user "${rabbitmq_user}" "${rabbitmq_pwd}" &>>$logfile
statusCheck $?
printHeader "Set Permissions to RabbitMQ User"
rabbitmqctl set_permissions -p / "${rabbitmq_user}" ".*" ".*" ".*" &>>$logfile
statusCheck $?