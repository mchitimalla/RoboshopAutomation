cp catalogue.service /etc/systemd/system/
cp mongo.repo /etc/yum.repos.d/mongo.repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install
systemctl daemon-reload
systemctl enable
systemctl start
yum install mongodb-org-shell -y
mongo --host 172.31.9.190 </app/schema/catalogue.js
