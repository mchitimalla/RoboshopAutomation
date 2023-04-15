cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
#Update the listening address to 0.0.0.0 in /etc/mongod.conf
systemctl enable mongod
systemctl start mongod