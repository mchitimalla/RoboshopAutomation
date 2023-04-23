src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=nginx
printHeader "InstallNginx"
yum install nginx -y
statusCheck $?
rm -rf /usr/share/nginx/html/*
statusCheck $?
cp roboshop.conf /etc/nginx/default.d/
statusCheck $?
curl -o /tmp/frontend.zip "${frontend_code_url}"
statusCheck $?
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
statusCheck $?
funcEnableService
statusCheck $?
