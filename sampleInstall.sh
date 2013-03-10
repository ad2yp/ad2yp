#!/bin/sh
#
# pseudo 'install script' for ad2yp
#
mkdir /etc/ad2yp
cp ad2yp.conf /etc/ad2yp/
chmod g-r,o-r /etc/ad2yp/ad2yp.conf
cp /etc/openldap/ldap.conf /etc/openldap/ldap.conf.orig
cp /etc/krb5.conf /etc/krb5.conf.orig
cp *.php /usr/local/sbin/
cp AD2NIS.sh /usr/local/sbin/
mkdir /var/yp/ypfiles
cp /var/yp/Makefile /var/yp/Makefile.orig
cp /var/yp/securenets /var/yp/securenets.orig
cp /etc/samba/smb.conf /etc/samba/smb.conf.orig
cp smb.conf /etc/samba/
#
# customize /etc/ad2yp/ad2yp.conf with your AD group info and service account for AD LDAP access.
#
# Set up PAM and kerberos using the wizard! 
#
# create some map files with AD2NIS.sh script (check LDAP is working).
#
#  Enable & start services ypserv, ypbind
#
# join system to active directory:
#
# net ads join -U <administrative username>
#
