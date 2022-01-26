#!/usr/bin/env bash

lliurex-version 2> /dev/null

if [ $? == 0 ]
then
    # Habilitar repo ubuntu
    sudo repoman-cli -y --enable 2
fi

# Actualitzar repositoris
#sudo apt update
# Instalar davmail
sudo apt install davmail

lliurex-version 2> /dev/null
if [ $? == 0 ]
then
    # Deshabilitar repo
    sudo repoman-cli -y --disable 2
fi


# SecureMode? 
read -p "Vols instalar certificat SSL? (S'usa en servidors d'Internet)(y/N): " install_cert
install_cert=${install_cert:-n}

if [ $install_cert == "y" ]
then
    password=`openssl rand -hex 4`

    read -p "Nom del host (host.domain.com o domain.com): " serverName
    read -p "Nom del l'organització (IES La Lluna): " orgName

    sudo keytool -genkey -keyalg rsa -keysize 2048 -storepass $password -keystore /etc/davmail/davmail.p12 -storetype pkcs12 -validity 3650 -dname cn=$serverName,ou=$orgName,o=sf,o=net
    
    #davmail.ssl.keystoreType=PKCS12
    oldString="davmail.ssl.keystoreType="
    newString="davmail.ssl.keystoreType=PKCS12"
    sudo sed -i "s/${oldString}/${newString}/" $davmailPropertiesFile
    
    #davmail.ssl.keyPass=password
    oldString="davmail.ssl.keyPass="
    newString="davmail.ssl.keyPass=${password}"
    sudo sed -i "s/${oldString}/${newString}/" $davmailPropertiesFile

    #davmail.ssl.keystoreFile=/etc/davmail/davmail.p12
    oldString="davmail.ssl.keystoreFile="
    newString="davmail.ssl.keystoreFile=\/etc\/davmail\/davmail.p12"
    sudo sed -i "s/${oldString}/${newString}/" $davmailPropertiesFile

    #davmail.ssl.keystorePass=password
    oldString="davmail.ssl.keystorePass="
    newString="davmail.ssl.keystorePass=${password}"
    sudo sed -i "s/${oldString}/${newString}/" $davmailPropertiesFile

    davmailServiceFile=/lib/systemd/system/davmail.service
    davmailPropertiesFile=/etc/davmail/davmail.properties

    # Fix bug: https://sourceforge.net/p/davmail/bugs/106/
    # ExecStart=/usr/bin/davmail -server /etc/davmail/davmail.properties
    oldString="ExecStart=\/usr\/bin\/davmail -server \/etc\/davmail.properties"
    newString="ExecStart=java -Djava\.net\.preferIPv4Stack=true -jar \/usr\/bin\/davmail -server \/etc\/davmail\.properties"
    echo "s/${oldString}/${newString}/g" $davmailServiceFile
    echo 
    sudo sed  "s/${oldString}/${newString}/g" $davmailServiceFile
fi


sudo systemctl daemon-reload
sudo systemctl restart davmail.service