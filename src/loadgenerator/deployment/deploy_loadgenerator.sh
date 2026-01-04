
# loadgenerator config
export FRONTEND_ADDR="34.65.49.161"
export USERS=200
export RATE=50
export RUN_TIME="2m"
export VM_COUNT=5

# save image tar to this directory
docker save -o loadgenerator.tar loadgenerator:latest
#

export GCP_privateKeyFile="./terraform-service.json"
export TF_VAR_project=$(gcloud config get-value project)

# create .json with service credentials
export service_account_name=$(
    gcloud iam service-accounts list \
        --project "$TF_VAR_project" \
        --format="value(email)" | head -n 1
)


if [ ! -f "$GCP_privateKeyFile" ]; then
  gcloud iam service-accounts keys create "$GCP_privateKeyFile" \
    --iam-account "$service_account_name"
else
  echo "Key file already exists: $GCP_privateKeyFile — skipping creation"
fi
#

export GCP_userID=$(gcloud config get-value account | sed 's/[@.]/_/g')
export TF_VAR_project=$(gcloud config get-value project)
export TF_VAR_region=$(gcloud config get-value compute/region)
export TF_VAR_zone=$(gcloud config get-value compute/zone)
export TF_VAR_instance_name="my-loadgenerator"
export TF_VAR_service_file=$GCP_privateKeyFile
export TF_VAR_user_id=$GCP_userID
export TF_VAR_vm_count=$VM_COUNT

export LOADGENERATOR_IMAGE_PATH="./loadgenerator.tar"

### Start VM with terraform

terraform init
terraform apply -auto-approve

# # get ip of started vm
# export LOADGENERATOR_VM_IP=$(terraform output -raw ip)
export LOADGENERATOR_VM_IPS=$(terraform output -json ips | jq -r '.[]')
echo $LOADGENERATOR_VM_IPS


# ### Run docker container with loadgenerator app on the vm
./create_inventory.py
ansible-playbook loadgenerator-conf.yml -i inventory --become


# destroy vm after loadgenerator finishes
terraform destroy -auto-approve






















