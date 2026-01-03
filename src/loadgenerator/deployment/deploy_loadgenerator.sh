
# loadgenerator config
export FRONTEND_ADDR="34.65.49.161"
export USERS=10
export RATE=1

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
gcloud iam service-accounts keys create "$GCP_privateKeyFile" --iam-account "$service_account_name"
#

export GCP_userID=$(gcloud config get-value account | sed 's/[@.]/_/g')
export TF_VAR_project=$(gcloud config get-value project)
export TF_VAR_region=$(gcloud config get-value compute/region)
export TF_VAR_zone=$(gcloud config get-value compute/zone)
export TF_VAR_instance_name="my-loadgenerator"
export TF_VAR_service_file=$GCP_privateKeyFile

export LOADGENERATOR_IMAGE_PATH="./loadgenerator.tar"

### Start VM with terraform

terraform init
terraform apply

# # get ip of started vm
export LOADGENERATOR_VM_IP=$(terraform output -raw ip)


# ### Run docker container with loadgenerator app on the vm


./create_inventory.py
ansible-playbook loadgenerator-conf.yml -i inventory --become






















