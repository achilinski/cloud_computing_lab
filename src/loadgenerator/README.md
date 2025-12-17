

# Instructon on how to deploy loadgenerator on google cloud, using Terraform and Ansible 

0. Build loadgenerator image from Dockerfile  (for x86_64: docker buildx build --platform linux/amd64 -t loadgenerator:latest --load .)
1. cd deployment
1. set the config variables in ./deploy_loadgenerator.sh
2. run the ./deploy_loadgenerator.sh script







