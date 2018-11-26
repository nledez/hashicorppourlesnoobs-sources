#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import argparse
import ovh
import sys

from pprint import pprint

parser = argparse.ArgumentParser()
parser.add_argument('-u', '--user', help='Create or show user.', required=True)
parser.add_argument('-r', '--region', help='Region to create user.', required=True)
args = parser.parse_args(sys.argv[1:])

# create a client using configuration
client = ovh.Client()

## Project

print('Projects:')
projects = client.get('/cloud/project')

if len(projects) == 1:
    project = projects[0]
else:
    print('Too many projects')
    sys.exit(1)

print('Project name: {}'.format(project))

project_info = client.get(
    '/cloud/project/{serviceName}'.format(serviceName=project)
)

pprint(project_info)

print()

## User

print('Users:')
users = client.get(
    '/cloud/project/{serviceName}/user'.format(serviceName=project)
)

user = None
for u in users:
    if u['description'] == args.user:
        user = u
        break

if not user:
    user = client.post(
        '/cloud/project/{serviceName}/user'.format(serviceName=project),
        description=args.user,
        role='admin'
    )

print('User {}:'.format(args.user))
pprint(user)

print()

# openrc = client.get(
#     '/cloud/project/{serviceName}/user/{userId}/openrc'.format(
#         serviceName=project,
#         userId=user['id'],
#     ),
#     region=args.region
# )
# open('openrc-{}-{}'.format(args.user, args.region), 'w').write(openrc['content'])

password = client.post(
    '/cloud/project/{serviceName}/user/{userId}/regeneratePassword'.format(
        serviceName=project,
        userId=user['id'],
    )
)

tokens = client.post(
    '/cloud/project/{serviceName}/user/{userId}/token'.format(
        serviceName=project,
        userId=user['id'],
    ),
    password=password['password']
)

#print(password['password'])

openstack_rc = tokens['token']

print('Create openrc-{}-{}'.format(args.user, args.region))

with open('openrc-{}-{}'.format(args.user, args.region), 'w') as openrc_file:
    openrc_file.write('export OS_IDENTITY_API_VERSION=2\n')
    openrc_file.write('export OS_AUTH_URL=https://auth.cloud.ovh.net/v2.0/\n')
    openrc_file.write('export OS_TENANT_ID={}\n'.format(openstack_rc['project']['id']))
    openrc_file.write('export OS_TENANT_NAME="{}"\n'.format(openstack_rc['project']['name']))
    openrc_file.write('export OS_USERNAME="{}"\n'.format(openstack_rc['user']['name']))
    openrc_file.write('export OS_PASSWORD="{}"\n'.format(password['password']))
    openrc_file.write('export OS_REGION_NAME="{}"\n'.format(args.region))

