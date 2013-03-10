<?php

//  /usr/local/sbin/ad2user-private-groups.php
//  construct NIS private group map from group containing users (use CN of group containing Unix users)
//  Need to add error checking.

    $conf = '/etc/ad2yp/ad2yp.conf';

//  check for alternate config file on command line

    if ($argc > 1) $conf = $argv[1];

    $args = file($conf, FILE_IGNORE_NEW_LINES)
          or die("Couldn't read $conf");

// args[0]  URI
// args[1]  bind DN
// args[2]  bind password
// args[3]  search base
// args[4]  CN of group containing Unix users (without the search base)
// args[5]  OU containing group definitions   ( " )
// args[6]  OU containing user accounts ( " )
// args[7]  OU containing private group definitions ( " )

    $uri = $args[0];

    $ad = ldap_connect($uri)
          or die("Couldn't connect to AD!");

    ldap_set_option($ad, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ad, LDAP_OPT_REFERRALS, 0);

    $bd = ldap_bind($ad,$args[1],$args[2])
          or die("Couldn't bind to AD!");

    $base = $args[3];
    $dn = "$args[4],$base";

    $attributes = array('dn','cn','displayname','objectsid','samaccountname');
    $filter = "(&(objectClass=User)(memberOf=$dn))";
    $result = ldap_search($ad, $base, $filter, $attributes, 0, 0, 0, LDAP_DEREF_NEVER);

    $account = ldap_get_entries($ad, $result);

    for ($i=0; $i<$account['count']; $i++)
    {

        $user=strtolower($account[$i]['samaccountname'][0]);
        echo "$user:x:";

        $sidinhex = str_split(bin2hex($account[$i]['objectsid'][0]), 2);

        // Byte 8 count of sub authorities - Get number of sub-authorities
        $subauths = hexdec($sidinhex[7]);

        $start = 8 + (4 * ($subauths-1));
        $urid = hexdec($sidinhex[$start+3].$sidinhex[$start+2].$sidinhex[$start+1].$sidinhex[$start]);

        echo $urid.':';

        echo $user."\n";

    }

    ldap_unbind($ad);
?>
