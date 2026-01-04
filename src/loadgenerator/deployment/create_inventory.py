#!/usr/bin/env python3

import os


ips = os.environ['LOADGENERATOR_VM_IPS'].split()
user = os.environ['GCP_userID']

with open('inventory', 'w') as host_file:
    host_file.write('[loadgenerator-vm]\n')
    for ip in ips:
        host_file.write(f'{ip} ansible_ssh_user={user} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"\n')