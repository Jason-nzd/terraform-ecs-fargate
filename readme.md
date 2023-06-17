# Terraform - Web Server ECS on AWS

This allows quick management and deployment of load-balanced web-servers running as an ECS cluster on AWS.

The terraform in folder `/ECR-Registry/` will setup a ECR registry only. It can be safely left deployed at very little cost.

The terraform in folder `/ECS-Service/` will deploy:

- VPC with Subnets and Security Groups
- ECS Cluster, ECS Task Definition and ECS Service
- Load Balancer and Target Group.

There is a small hourly cost for running this, so it should be taken down when not needed.

This project requires Docker and Terraform to be installed, and AWS credentials to be set.

## Setting up ECR

`cd` into `/ECR-Registry/` and check `variables.tf`. If any need to be overridden, create a `local.tfvars` file and place the overridden variables in there.

Run `terraform apply` to create the infrastructure, or `terraform apply -var-file="local.tfvars"` if using overridden variables.

After creation, docker login, tag, push cmds will be provided as `terraform output` outputs for quick access.

### Steps For Deploying

- First build a docker ready project with a cmd similar to `docker build -t my-image .`
- Login to docker with the `terraform output` cmd starting with `docker login`.
- Tag the image with the `terraform output` cmd starting with `docker tag`.
- Push the image to ECR with the `terraform output` cmd starting with `docker push`.

The ECR registry now stores your image and is ready to be pulled from by ECS.

## Setting up ECS

`cd` into `ECS-Service` and check `variables.tf` for anything that needs to be changed.
Create a `local.tfvars` file and manually set the variable `ecr_repository_uri` to the output from ECR `ecr_repository_uri`.

Run `terraform apply -var-file="local.tfvars"` to create the infrastructure.

After the infrastructure has been created, the address for the Load Balancer will be provided via `terraform output`.

## Cleaning up

`cd` into `ECS Service` run `terraform destroy` to destroy the infrastructure. Repeat the steps for the `ECS Registry` folder.
