#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "<h1>Dev EC2 is running</h1>" > /var/www/html/index.html
