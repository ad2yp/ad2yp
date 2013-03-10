<?php

//  /usr/local/sbin/ad2group.php
//  convert group definitions in an OU to NIS map equivalents.  Need to add error checking.
//  register_argc_argv must be enabled for command line specified config file

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

    $attributes = array('dn','objectclass','cn','member','distinguishedname','name','objectsid','samaccountname');
    $filter = '(objectClass=group)';
    $base = $args[3];
    $ou = "$args[5],$base";
    $result = ldap_search($ad, $ou, $filter, $attributes, 0, 0, 0, LDAP_DEREF_NEVER);

    $object = ldap_get_entries($ad, $result);

    for ($i=0; $i<$object['count']; $i++)
    {
//      if ($object[$i]['member']['count'] === 0) continue;

        $cn=$object[$i]['cn'][0];
        echo "$cn:x:";

        $sidinhex = str_split(bin2hex($object[$i]['objectsid'][0]), 2);
        // Byte 8 count of sub authorities - Get number of sub-authorities
        $subauths = hexdec($sidinhex[7]);

        $start = 8 + (4 * ($subauths-1));
        $rid = hexdec($sidinhex[$start+3].$sidinhex[$start+2].$sidinhex[$start+1].$sidinhex[$start]);

        echo $rid.':';

        for ($j=0; $j<$object[$i]['member']['count']; $j++)
        {
            if ($j != 0) echo ',';

            $attributes = array('dn','cn','samaccountname');
            $dn = $object[$i]['member'][$j];
            $filter = "(samAccountName=*)";
            $result = ldap_search($ad, $dn, $filter, $attributes, 0, 0, 0, LDAP_DEREF_NEVER);
            $member = ldap_get_entries($ad, $result);

            echo strtolower($member[0]['samaccountname'][0]);

        }
        echo "\n";
    }

    ldap_unbind($ad);

?>
