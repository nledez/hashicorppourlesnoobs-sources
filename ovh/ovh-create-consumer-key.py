#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import ovh

# create a client using configuration
client = ovh.Client()

# Request RO, /me API access
#access_rules = [
#        {'method': 'GET', 'path': '/me'},
#]

access_rules = [
        {'method': 'GET', 'path': '/*'},
        {'method': 'POST', 'path': '/*'},
        {'method': 'PUT', 'path': '/*'},
        {'method': 'DELETE', 'path': '/*'}
        ]

# Request token
validation = client.request_consumerkey(access_rules)

print("Please visit %s to authenticate" % validation['validationUrl'])
input("and press Enter to continue...")

# Print nice welcome message
print("Welcome", client.get('/me')['firstname'])
print("Btw, your 'consumerKey' is '%s'" % validation['consumerKey'])
