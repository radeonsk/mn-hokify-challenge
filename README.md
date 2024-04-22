# MN-hokify-challenge

## AWS infrastructure

AWS infrastructure is provisioned via Terraform. Terraform code is in `/terraform` folder.

### Prerequisites
- Configured access to AWS account
- Github token for self-hosted runner stored in AWS Parameter store with name `github-token` (in the same account and region as infrastructure will be provisioned)

### Provisioning
- Just run `terraform apply` in `/terraform` folder

### Description
Infrastructure is very simple. Resources provisioned:
- One VPC with one subnet
- This subnet is using routing table with Internet Gateway for Internet traffic
- Security group for EC2 instance which allows outgoing traffic to the Internet and incoming traffic on port 8080
- AWS key pair (public and private key stored in Parameter Store) to be used for EC2 instance
- IAM instance profile and role for EC2 instance with attached policy for AWS Systems Manager (so that instance can access Parameter Store and also we can connect to the instance via Session Manager)
- EC2 instance running Ubuntu 22.04 with attached public Elastic IP address. Docker, AWS CLI v2 and Github self-hosted runner will be installed during initial startup (during installation of Github self-hosted runner, the token needed for authorization is obtained from Parameter Store).

*In real world the infrastructure would be a little bit more complicated. But for this challenge I tried to make it as simple as possible.*

*For example, it would be better to run some Load Balancer in front of the EC2 instance. Also it would be better to run Github self-hosted runner on some other instance and also to use dedicated image repository (for example ECR) so that images can be stored properly after the build.*

*For real production use (more complicated apps, more apps running) this solution would not be enough. Probably some Kubernetes cluster (EKS) would be needed, with proper image repository (ECR), load balancer running in front of it, proper monitoring configured, etc...*

## Application
Application is very simple and is located in `/app` folder.

## GitHub Actions
There is one GitHub Action configured: **Build & deploy hokify challenge app** which can be run manually. Configuration is stored in file: `.github/workflows/actions.yml`

All steps for this pipeline are running in Github self-hosted runner (which is running on provisioned EC2 instance):
- Checkout the code
- Build docker image
- Stop and remove old image
- Run new docker image

*I have chosen self-hosted runner so that all the pipeline steps are run on the EC2 instance (it simplifies the pipeline a bit and no additional ports need to be opened from the EC2 instance to the Internet).*
