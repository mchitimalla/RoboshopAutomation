yum install nginx -y
rm -rf /usr/share/nginx/html/*
cp roboshop.conf /etc/nginx/default.d/
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl enable nginx
systemctl start nginx
