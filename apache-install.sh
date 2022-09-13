# vim apache-install.sh

#!/bin/bash

yum install httpd -y

echo "<h1><center>Terraform Provisoner version-2</center></h1>" > /var/www/html/index.html
systemctl restart httpd.service
systemctl enable httpd.service
