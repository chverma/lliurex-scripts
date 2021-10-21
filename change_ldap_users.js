const fs = require('fs');

var data = require('./llum_data.json')
var users = data.users
var groups = data.groups
var nUsers = Object.keys(users).length;
var nGroups = Object.keys(groups).length;
console.log("Num users", nUsers, "; Num groups:", nGroups)

var niaAttr = 'x-lliurex-nia'
var nifAttr = 'x-lliurex-nif'

var userNames = Object.keys(users)
name = ""
newName = ""
for (i=0; i< nUsers; i++) {
    var user = users[userNames[i]]

    if (user.profile == 'Students') {
        newName = user[niaAttr]
        // Remove first 0.
        var nif = String(user[nifAttr])
        while(nif.charAt(0) === '0')
        {
            nif = nif.substring(1)
        }
        var newPasswd
        // Be careful with users without nif
        if(nif != 'undefined' )
            newPasswd = nif
        else
            newPasswd = newName
        user.userPassword = newPasswd
        data.users['al'+newName] = JSON.parse(JSON.stringify(user))

        delete data.users[userNames[i]]
        name = userNames[i]
    }

}


let data2 = JSON.stringify(data);
fs.writeFileSync('new_llum_data.json', data2);
