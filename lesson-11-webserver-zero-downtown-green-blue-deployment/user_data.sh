#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Terraform V3</h2>
<br>
My ip is: $myip
</html>
EOF

sudo service httpd start
chkconfig httpd on