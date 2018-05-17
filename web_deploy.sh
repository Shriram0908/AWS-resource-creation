#! /bin/bash

yum -y update
yum -y install httpd
systemctl enable httpd
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py
pip install awscli --upgrade
aws s3 cp s3://terraform-backed/HTML/ /var/www/html/ --recursive
systemctl start httpd 