# policy.d/filter -> al final


filter_ssid {
if (&LDAP-Group == "teachers" && &Called-station-id !~ /.*SSID1/) {
                        update request {
                                &Module-Failure-Message += 'Rejected: Usuari no pertany a teachers i intenta connectar a la xarxa de personal'
                        }
                        reject
                }

if (&LDAP-Group == "students" && &Called-station-id !~ /.*SSID12/) {
                        update request {
                                &Module-Failure-Message += 'Rejected: Usuari no pertany a students i intenta connectar a la xarxa de alumnes'
                        }
                        reject
                }


}



# sites-available/default -> abans de expiration i després de -ldap

filter_ssid

# No ha d'haver un default group de lliurex
