#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import ovh
import sys

from pprint import pprint

# create a client using configuration
client = ovh.Client()

## Vrack

vracks = client.get('/vrack')

if len(vracks) == 1:
    vrack = vracks[0]
else:
    print('Too many vracks')
    sys.exit(1)

print('Vrack name: {}'.format(vrack))

vrack_info = client.get('/vrack/{serviceName}'.format(serviceName=vrack))

pprint(vrack_info)

print()

## Project

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

## Connect project to vrack

connected = client.get(
    '/vrack/{serviceName}/cloudProject'.format(serviceName=vrack)
)

print('Connected:')
pprint(connected)

tasks = client.get(
    '/vrack/{serviceName}/task'.format(serviceName=vrack)
)

# FIXME if tasks > 0
print('Tasks:')
pprint(tasks)

if len(connected) == 0:
    connect = client.post(
        '/vrack/{serviceName}/cloudProject'.format(serviceName=vrack),
        project=project
    )

    pprint(connect)

print()

## Create private network on public cloud

private_networks = client.get(
    '/cloud/project/{serviceName}/network/private'.format(serviceName=project)
)

print('Private networks:')

if len(private_networks) == 0:
    private_network_info = client.post(
        '/cloud/project/{serviceName}/network/private'.format(serviceName=project),
        name='Private',
        vlanId=1
    )

    private_network = private_network_info[0]['id']
elif len(private_networks) == 1:
    private_network_info = private_networks[0]
    private_network = private_network_info['id']
else:
    print('Too many private networks')
    pprint(private_networks)
    sys.exit(1)

print('Private networks name: {}'.format(private_network))
pprint(private_network_info)

print()

## Create subnets

print('Subnets:')

subnets = client.get(
    '/cloud/project/{serviceName}/network/private/{networkId}/subnet'.format(
    serviceName=project,
    networkId=private_network)
)

pprint(subnets)

if len(subnets) == 0:
    subnet_index = 0
    for region in private_network_info['regions']:
        if region['status'] == 'ACTIVE':
            print('Create subnet on {}'.format(region['region']))
            subnet_index += 1
            subnet_network = '192.168.{}.0/24'.format(subnet_index)
            subnet_start = '192.168.{}.10'.format(subnet_index)
            subnet_end = '192.168.{}.249'.format(subnet_index)
            subnet_creation = client.post(
                '/cloud/project/{serviceName}/network/private/{networkId}/subnet'.format(
                    serviceName=project,
                    networkId=private_network
                ),
                region=region['region'],
                dhcp=True,
                network=subnet_network,
                start=subnet_start,
                end=subnet_end,
                noGateway=True,
            )
            pprint(subnet_creation)
