src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=nginx
printHeader "InstallNginx"
yum install nginx -y &>>$logfile
statusCheck $?
rm -rf /usr/share/nginx/html/* &>>$logfile
statusCheck $?
cp roboshop.conf /etc/nginx/default.d/ &>>$logfile
statusCheck $?
curl -o /tmp/frontend.zip "${frontend_code_url}" &>>$logfile
statusCheck $?
cd /usr/share/nginx/html &>>$logfile
unzip /tmp/frontend.zip &>>$logfile
statusCheck $?
funcEnableService
statusCheck $?
