

### Configuration

export GCP_userID=""
export GCP_privateKeyFile=""
export TF_VAR_project=""
export TF_VAR_region=""
export TF_VAR_zone=""
export TF_VAR_instance_name=""
export TF_VAR_service_file=""


export FRONTEND_ADDR=""
export USERS=10
export RATE=1

export LOADGENERATOR_IMAGE_PATH=""

### Start VM with terraform

terraform init
terraform apply

# get ip of started vm
export LOADGENERATOR_VM_IP=$(terraform output -raw ip)


### Run docker container with loadgenerator app on the vm

./create_inventory.py
ansible-playbook loadgenerator-conf.yml -i inventory --become






















