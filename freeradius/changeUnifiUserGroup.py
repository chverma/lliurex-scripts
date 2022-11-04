#!/usr/bin/env python3
import sys
import requests
import os
from dotenv import load_dotenv

load_dotenv()

# Needs two params
clientMAC = sys.argv[1].replace('-', ':').lower()
# This param must be 0 or 1
isDefaultIdGroup = int(sys.argv[2])


# If is default group, put it empty
idDefaultGroup = ''
# Id of Unifi group to be changed
idAlumnatFP = os.getenv('ID_ALUMNAT_FP')

# Credentials and base URL
username = os.getenv('UNIFI_ADMIN')
password = os.getenv('UNIFI_PASSWORD')
unifiURLBase = os.getenv('UNIFI_URL')

s = requests.Session()
# Login
dataLoginJson = {'username': username, 'password': password, 'remember': True}
x = s.post(unifiURLBase+'/api/login', json = dataLoginJson, verify=False)

# Get clients on gz (json)
headers = {}
headers['Accept'] = 'text/json,text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'
x = s.get(unifiURLBase+'/api/s/default/rest/user', verify=False, headers=headers)
clients = x.json()['data']

# Get client Id
clientId = ''
for client in clients:
    if client['mac'] == clientMAC:
        clientId = client['_id']

# Change group on unifi
if clientId != '':
    idGroup = idDefaultGroup
    if isDefaultIdGroup == 0:
        idGroup = idAlumnatFP

    groupJson = {'noted':False,'usergroup_id':idGroup}
    headers = {}
    headers['Content-Type'] = 'application/json;charset=utf-8'
    x = s.put(unifiURLBase+'/api/s/default/rest/user/'+clientId, verify=False, json=groupJson, headers=headers)
