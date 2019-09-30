#!/bin/sh
if [ x$1 == x"postcustomization" ]; then
# this script only executed when guest operating system is booted.
echo "Started doing post-customization steps..."
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
# sleep 2 seconds
sleep 2
firewall-cmd --reload
# download and install apache
yum -y install httpd
systemctl enable httpd
# start apache service
systemctl start httpd.service > /dev/null &
sleep 60
touch /var/www/html/index.html
# write some text to welcome page...
echo "Welcome to DCS from $HOSTNAME :-)" > /var/www/html/index.html
fi