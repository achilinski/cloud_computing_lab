#!/usr/bin/env python3

import os

with open('inventory', 'w') as host_file:
    host_file.write('[loadgenerator-vm]\n')
    host_file.write(f'{os.environ['LOADGENERATOR_VM_IP']} ')
    host_file.write(f'ansible_ssh_user={os.environ['GCP_userID']} ')
    host_file.write(f'ansible_ssh_common_args=\'-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \'')