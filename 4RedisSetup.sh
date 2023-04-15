yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y
#Update listening address to 0.0.0.0 in /etc/redis.conf
systemctl enable redis
systemctl start redis