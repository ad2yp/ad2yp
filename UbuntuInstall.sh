#!/bin/sh
#
# pseudo 'install script' for ad2yp on Ubuntu LTS x86_64 as the NIS server
# https://help.ubuntu.com/community/SettingUpNISHowTo/
# For Kerberos look here: 
# https://help.ubuntu.com/community/Kerberos/
# http://www.alittletooquiet.net/text/kerberos-on-ubuntu/
# http://doc.akka.io/docs/akka/1.3.1/scala/security.html
# substitute kerberos/nis for winbind--similar to:
# http://wiki.debian.org/Authenticating_Linux_With_Active_Directory
#
sudo apt-get install ntp
sudo apt-get install samba
sudo apt-get install php-cli php5-ldap
sudo apt-get install portmap nis
sudo apt-get install krb5-user krb5-config
sudo apt-get install krb5-clients
sudo apt-get install libpam-krb5
sudo apt-get install libpam-ccreds
sudo mkdir /etc/ad2yp
sudo cp ad2yp.conf /etc/ad2yp/
sudo chmod g-rwx,o-rwx /etc/ad2yp/ad2yp.conf
sudo mv /etc/ldap/ldap.conf /etc/ldap/ldap.conf.orig
sudo cp ldap.conf /etc/ldap/
sudo mv /etc/krb5.conf /etc/krb5.conf.orig
sudo cp krb5.conf /etc/
sudo cp *.php /usr/local/sbin/
sudo cp AD2NIS.sh /usr/local/sbin/
sudo mkdir /var/yp/ypfiles
sudo mv /var/yp/Makefile /var/yp/Makefile.orig
sudo cp Makefile.LTS /var/yp/Makefile
sudo mv /etc/ypserv.securenets /etc/ypserv.securenets.orig
sudo cp securenets /etc/ypserv.securenets
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo cp smb.conf /etc/samba/
sudo cp /etc/default/nis /etc/default/nis.orig
sudo vi /etc/default/nis
sudo vi /etc/yp.conf
sudo /usr/lib/yp/ypinit -m
sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.orig
sudo vi /etc/nsswitch.conf
sudo shutdown -r now
sudo net ads join -U <administrative username>
sudo pam-auth-update --remove winbind
sudo cp common-krb5 /etc/pam.d/
sudo cp /etc/pam.d/login /etc/pam.d/login.orig
#
#/etc/yp.conf should contain a domain line and a ypserver line for client:
#
#domain        <Name of NIS domain here>
#ypserver      <IP of NIS server here>
#
# customize /etc/ad2yp/ad2yp.conf with your AD group info and service account for AD LDAP access.
#
# edit /etc/nsswitch.conf to use files nis for passwd and group
#
##passwd:         compat
#passwd:         files nis
##group:          compat
#group:          files nis
#
# create some map files with AD2NIS.sh script (check LDAP is working).
#
#  Enable start services ypserv, ypbind
#
# sudo /usr/lib/yp/ypinit -m
#   next host to add: <host name of system>
#   ^D
#
# edit /etc/hosts and add <IP address of system> <host name of system>
# reboot?
#
# load maps generated using LDAP into NIS:
# sudo /var/yp/make
#
# join system to Active Directory:
# sudo net ads join -U <administrative username>
#
