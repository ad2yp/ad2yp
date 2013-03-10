#!/bin/bash
# AD2NIS.sh
#
cd /var/yp/ypfiles
touch error.log
php /usr/local/sbin/ad2user-private-groups.php 2>>error.log > private-group.map
php /usr/local/sbin/ad2group.php 2>>error.log > group.map
php /usr/local/sbin/ad2user-private.php 2>>error.log > user.map
cp user.map passwd
cp user.map master.passwd
cp private-group.map group
cat group.map >> group
cd /var/yp/
make
cd
