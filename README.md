# stsg-container-app
## Description
Repository that contains a terraform project and a docker based django app.
Using github actions properly configured, build the image and publish on a Dockerhub repository, to use it in the terraform project, that deploys an ECS application and associated resources necessary to work. (s3 and RDS)

## Assumptions
This project needs a properly configured VPC in the AWS account with public and private subnets.
Also, we need to have a Docker repository (Dockerhub or ECR) to publish the image. For simplicity purposes, this project use a public repository, but is possible to configure it to work with private repositories.

## Questions to answer
- How would you provision infrastructure?

I have decided to use ECS fargate because is a fast way to deploy a container application and forgot many maintenance tasks, allowing us to focus in the development of the app and the infrastructure. It was doing by terraform because it maintains the infrastructure as a code basis and offers an state that detects infrastructure changes outside of the code, also allows to deposit the code in a repository to have a version control. This offers us mutability and fast disaster recovery.

- How would you setup CI / CD?

I have chosen Github actions because their simplicity to integrate with a Github repository and because allows us to configure all the environments needed to do each action.

- Is it advisable to use a container technology? Can you elaborate on advantages and
disadvantages?

Yes, because a container application is more mutable and faster to allow changes in their infrastructure without being affected.

- How do you deploy code the provisioned infrastructure?

Using terraform and github actions.

- How do you ensure that the service can connect to the database? (connection string,
credentials, permissions)

Doing the project by terraform, you can consider the links between the resources a condition to make sure the connection parameters.

- How do you ensure that the service can access S3 securely?

I use a private ACL and a role based access that only allows the access to the ECS task role.

- How do you monitor performance and availability?

ECS provides basic metrics and logging that can accomplish a first stage of monitoring.
Using ECS with fargate we won't have any problem of availability because it's like a SaS.

- What about scalability?

With the basic monitoring provided by Cloudwatch, we can monitor the critic metrics to change the parameter of the replicas deployed.

- Security considerations

I have decided to use a private tier for database, without internet access to protect their data, and using least permission and role based IAM access to other resources in AWS. To the next steps and add an additional security layer, it's needed to add a load balancer with TLS certificates to provide HTTPS access to the service exposed if it will be faced by the public network.

## Terraform Project Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |


### Resources

| Name | Type |
|------|------|
| [aws_db_instance.test_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.test_rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecs_cluster.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.test_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.test_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.test_ecs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.test_ecs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.test_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.test_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.test_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.test_ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.test_rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.rds_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.secrets_ecs_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.test_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.test_ecs_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.sandbox_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpcs.vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | n/a | `string` | n/a | yes |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | n/a | `number` | n/a | yes |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | n/a | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_postgres_engine_version"></a> [postgres\_engine\_version](#input\_postgres\_engine\_version) | n/a | `string` | `"14.4"` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | n/a | `string` | n/a | yes |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | n/a | `string` | `"db.t3.micro"` | no |
| <a name="input_rds_port"></a> [rds\_port](#input\_rds\_port) | n/a | `string` | `"5432"` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region to deploy infrastructure on it | `string` | n/a | yes |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Number of subnets to deploy in each tier | `number` | n/a | yes |


## How to reproduce it
You need to uncomment the terraform apply stage in the github-actions.yml, and prepare your AWS account with the resources needed (VPC, subnets and Github Actions role with proper permissions, also configure the necessary secrets in the repo). 

A qa terraform environment is provided to reproduce the project.

## Local Testing

To test the app locally, you can use the docker-compose.yml file that are provided in the docker folder. You need to have the AWS credentials configured as environment variables in your machine to allow the container to hierate it. Also, you need to configure an .env file with the variables to fill it in the deployment.