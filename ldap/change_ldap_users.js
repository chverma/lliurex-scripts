const fs = require('fs');
const xpath = require('xpath');
const DOMParser = require('xmldom').DOMParser;
const calculateNT = require('./hash.js').calculateNT;
const { execSync } = require('child_process');


var data = require('./llum_data.json');
var xmlData = fs.readFileSync('./llxgesc.dat').toString().replace(/\r\n?/g, '\n');
var dom = new DOMParser().parseFromString(xmlData);

var users = data.users;
var groups = data.groups;
var nUsers = Object.keys(users).length;
var nGroups = Object.keys(groups).length;



console.log('Num users', nUsers, '; Num groups:', nGroups)

var niaAttr = 'x-lliurex-nia'
var nifAttr = 'x-lliurex-nif'

var userNames = Object.keys(users);
newName = ''
for (i = 0; i < nUsers; i++) {
    var user = users[userNames[i]];

    if (user && user.profile == 'Students') {
        newName = user[niaAttr];
        // Remove first 0.
        var nif = String(user[nifAttr]);
        while (nif.charAt(0) === '0') {
            nif = nif.substring(1);
        }
        var newPasswd;
        // Be careful with users without nif
        if (nif != 'undefined')
            newPasswd = nif;
        else
            newPasswd = newName;
        user.userPassword = newPasswd;
        data.users['al' + newName] = JSON.parse(JSON.stringify(user));

        delete data.users[userNames[i]];
        userName = userNames[i];
        // TODO: Change groups of student
        console.log(userName, newName)

    } else if (user && user.profile == 'Teachers') {
        var result = xpath.evaluate(
            `//professor[ cognoms = "${user.sn}" and nom = "${user.cn}"]/document`, // xpathExpression
            dom, // contextNode
            null, // namespaceResolver
            xpath.XPathResult.ANY_TYPE, // resultType
            null // result
        );

        node = result.iterateNext();
        nProfes = 0;

        while (node) {
            nProfes++;
            nif = node.firstChild.data;
            node = result.iterateNext();
        }

        if (nProfes == 1) {
            while (nif.charAt(0) === '0') {
                nif = nif.substring(1);
            }
            user.userPassword = nif;
            user.known_password = nif;

            user.sambaLMPassword = execSync(`python3 calculateLMPassword.py ${nif}`, options = {
                encoding: 'utf8'
            }).replace('\n', '');
            user.sambaNTPassword = calculateNT(nif);

            console.log(user.sambaNTPassword, user.sambaLMPassword, nif);
        } else if (nProfes == 0) {
            console.log('Sense nif ' + nProfes);
            console.log(user);
        } else {
            console.log('Més d\'un nif ' + nProfes);
            console.log(nif);
            console.log(user);
        }
    }
}


let data2 = JSON.stringify(data);
fs.writeFileSync('new_llum_data.json', data2);
