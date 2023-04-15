yum install nginx -y
rm -rf /usr/share/nginx/html/*
cp roboshop.conf /etc/nginx/default.d/
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl enable nginx
systemctl start nginx
