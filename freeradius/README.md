# What we do?

1. Allow students and teachers to use their own wireless networks.
2. For FP students, apply their VLAN classroom and increment default bandwidth
3. On Unifi Controller, we have default bandwidth per wireless network. But, we can change client group profile in order to increment bandwidth


# What we modify?
## Modify sites-available/default

        post-auth {

                if (LDAP-Group == "aula22a") {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 21
                        }
                        changeunifigrouptofp
                } else if (LDAP-Group == "aula23a") {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 22
                        }
                        changeunifigrouptofp
                } else if (LDAP-Group == "aula27a") {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 27
                        }
                        changeunifigrouptofp
                } else if (LDAP-Group == "aula28a") {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 28
                        }
                        changeunifigrouptofp
                } else if (LDAP-Group == "aula32a") {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 400
                        }
                        changeunifigrouptofp
                } else {
                        update reply {
                            Tunnel-type = VLAN
                            Tunnel-medium-type = 6
                            Tunnel-Private-Group-Id = 400
                        }

                        changeunifigrouptodefault
                }
        ...

## Modify on mods-available/eap
        use_tunneled_reply = yes
        copy_request_to_tunnel = yes

## Modify on policy.d/filter
        filter_ssid {
            if (&LDAP-Group == "teachers" && &Called-station-id !~ /.*wifi_iestacio_personal/) {
                update request { &Module-Failure-Message += 'Rejected: Usuari no pertany a teachers i intenta connectar a la xarxa de personal' }
                reject
            }

            if (&LDAP-Group == "students" && &Called-station-id !~ /.*wifi_iestacio_alumnes/) {
                update request { &Module-Failure-Message += 'Rejected: Usuari no pertany a students i intenta connectar a la xarxa de alumnes' }
                reject
            }

        }

# How to install
## Using make
        make install

## or
### Backup files
        mv /etc/freeradius/3.0/sites-available/default{,.backup}
        mv /etc/freeradius/3.0/mods-enabled/eap{,.backup}
        mv /etc/freeradius/3.0/policy.d/filter{,.backup}

### Create symbolic links
        ln -s /usr/bin/changeunifigroup/changeunifigrouptodefault /etc/freeradius/3.0/mods-enabled/changeunifigrouptodefault
        ln -s /usr/bin/changeunifigroup/changeunifigrouptofp /etc/freeradius/3.0/mods-enabled/changeunifigrouptofp

### Create symbolic links
        ln -s /usr/bin/changeunifigroup/default /etc/freeradius/3.0/sites-available/default
        ln -s /usr/bin/changeunifigroup/eap /etc/freeradius/3.0/mods-enabled/eap
        ln -s /usr/bin/changeunifigroup/filter /etc/freeradius/3.0/policy.d/filter