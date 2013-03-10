ad2yp -- Utilities to export NIS user and group maps from active directory
         for kerberos+NIS authentication in Linux, BSD and others. 

uidnumber and gidnumber are set to the relative ID number of the object in active directory,
similar to the "idmap config ADIRECTORY: backend = rid" mechanism in samba.

Limitation: The scripts do not understand security groups that contain other security groups as members.
The ad2group scripts only convert groups that contain user accounts as members to NIS group maps.
No automatic name mangling, except to lowercase user names.
Limited by the number of results returned by Active Directory.

Requires: nis, samba, kerberos, php-ldap, php-cli, and dependencies

example files may include:

ad2yp.conf -- bogus (example) config file contents.

ldap.conf -- because the SSL certificates were not from a certificate authority.

krb5.conf -- example kerberos with some settings for single sign on. 

smb.conf -- for the "net ads join" command to join the Active Directory Domain

Reference How To for NIS:

http://web.archive.org/web/20110717184557/http://www.vanemery.com/DAS/DAS-manual.html
