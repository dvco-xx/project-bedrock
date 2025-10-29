Project Bedrock: My Cloud Engineering Journey

Deploying Microservices on AWS EKS
----------------------------------

Objective
----------
Build cloud infrastructure using Terraform (Infrastructure as Code)
Deploy the retail-store microservices app to Kubernetes
Set up automation with GitHub Actions


Core Features
--------------
Infrastructure:

1 VPC with public and private subnets across 2 availability zones
An EKS cluster running Kubernetes 1.28
2 t3.medium EC2 nodes (auto-scales if required)
Security groups, Developer IAM roles, NAT gateways

Application
------------
5 microservices deployed:

- UI
- Catalog
- Cart
- Orders
- Checkout


In-cluster databases
---------------------
- Redis (for caching)
- RabbitMQ (for messaging)
- PostgreSQL and MySQL (for data storage)



Developer Access
----------------
Create read-only developer user.
Set up RBAC

# CI/CD Automation
------------------

GitHub Actions workflow (./github/workflows) that automatically validates and deploys the Terraform code
GitFlow branching - feature branches → develop → main
All actions run automatically, then deploys to AWS when merged to main branch

# Step-by-Step Journey
--------------------
Step 1:
Set Up Local Environent
-----------------------
I started by setting up my local environment by installing the required dependencies,
by installing terraform using the command 'brew install terraform' (Mac), and kubernetes from the source build via the following command:
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl (gave it the necessary executable permissions)
sudo mv kubectl /usr/local/bin/ (moved it to the root path)

Then I ran the following commands to check the versions of the installed dependencies,
terraform version
aws --version
kubectl version --client

Next I configured AWS by running:
aws configure
then entering my AWS access key, secret key, and setting the default region to us-east-1

Then ran the command, 'aws sts get-caller-identity' to ensure it worked.

# Step 2:
Clone Repository (GitHub)
-------------------------
I created a GitHub repo for the project and cloned it via https using the command: 'git clone https://github.com/dvco-xx/project-bedrock.git'
Next, I created the folder structure for the project using:
mkdir -p terraform kubernetes .github/workflows docs

#  Step 3: 
Building The Infrastructure with Terraform
------------------------------------------

I created the necessary terraform files,
cd terraform
touch variables.tf, vpc.tf, iam.tf, eks.tf, outputs.tf

Then initialized Terraform using,
terraform init

This downloaded all the AWS provider plugins and set up the backend, I then ran 'terraform plan' to review what would be created.

And then 'terraform apply' to actually create everything.

After waiting for about 12 mins, it created the following resources:

- A VPC with all the networking and subnets,
- An EKS cluster,
- 2 EC2 nodes,
- Security groups,
- IAM roles

# Step 4: 
Connecting to The Kubernetes Cluster
------------------------------------
Once the cluster was created, I updated my kubeconfig using:
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster

Then checked if it worked with:
kubectl cluster-info
kubectl get nodes

# Step 5: 
Deploying The Application
-------------------------
The retail-store-sample-app uses Helm charts, so I installed the Helm dependency and created a namespace:
kubectl create namespace retail-store

Then cloned the app from the awscontainers github repo (https://github.com/aws-containers/retail-store-sample-app):
git clone https://github.com/aws-containers/retail-store-sample-app.git

Then I deployed each microservice using Helm:
helm install ui retail-store-sample-app/src/ui/chart --namespace retail-store
helm install catalog retail-store-sample-app/src/catalog/chart --namespace retail-store
helm install cart retail-store-sample-app/src/cart/chart --namespace retail-store
helm install orders retail-store-sample-app/src/orders/chart --namespace retail-store
helm install checkout retail-store-sample-app/src/checkout/chart --namespace retail-store


kubectl get pods -n retail-store --watch

Then I waited about 2-5 mins for everything to be up and running.

Some Issues I ran into: 
The UI service wasn't accessible at first. I eventually discovered it was a ClusterIP service, not a LoadBalancer. But I fixed it using the command:
kubectl patch svc ui -n retail-store -p '{"spec": {"type": "LoadBalancer"}}'

Now I could access the app details using:
kubectl get svc ui -n retail-store

I then retrieved the external URL (a39ac26f4e7914b289a285ea450d1d03-1855235943.us-east-1.elb.amazonaws.com) and opened it in my browser. 

# Step 6:
Setting Up Developer Access
---------------------------
I created a read-only IAM user and got the developer credentials from Terraform using the commands:
cd terraform
terraform output developer_username
terraform output developer_access_key_id
terraform output developer_secret_access_key
cd ..

Then I created RBAC (role-based access control) to give this user read-only access:
kubectl apply -f kubernetes/developer-rbac.yaml

and then verified it was set up using:
kubectl get clusterrole developer-readonly
kubectl get clusterrolebinding developer-readonly-binding

This enables the developer user to:
- View pods and logs
- List services and deployments
But restricts his/her access to delete or modify anything.


# Step 7
Setting Up the CI/CD Pipeline
-----------------------------
I created a GitHub Actions workflow file
.github/workflows/terraform-deploy.yml
nano .github/workflows/terraform-deploy.yml

Then I added GitHub Secrets for AWS credentials in the GitHub settings page.

# Some issues I hit along the way:
- Terraform formatting errors (fixed with terraform fmt)
- Deprecated GitHub Actions versions which prevented the actions file from running (had to update from v3 to v4),
- Permissions errors on PR comments (just removed the comments section entirely)

Eventually it worked so that now when I create a feature branch and push the code, it creates a PR to the develop branch,
GitHub Actions automatically runs terraform validate and terraform plan,
When merged to main, it runs 'terraform apply'

Step 8: 
Implementing GitFlow
--------------------
I set up efficient branching by creating 2 branches for development and features:

# Created develop branch:
git checkout -b develop
git push -u origin develop

# Created features branch:
git checkout -b feature/my-feature
# make changes
git push -u origin feature/my-feature
# Create PR to develop
# Merge after review
# Create PR from develop to main
# Merge to main to run CI/CD

This keeps everything organized and prevents me from accidentally breaking production.

# If you want to try it yourself:

Prerequisites:
--------------
bashterraform --version        # Need v1.0+
aws --version             # Need v2
kubectl version --client  # Need recent version
git --version

The Actual Steps (Summary):
---------------------------
# 1. Clone and setup
git clone https://github.com/dvco-xx/project-bedrock.git
cd project-bedrock

# 2. Configure AWS
aws configure
# Enter your access key, secret key, region us-east-1

# 3. Deploy infrastructure (THIS TAKES APPROX. 15 MINUTES)
cd terraform
terraform init
terraform plan
terraform apply  # Say yes when prompted
cd ..

# 4. Setup kubectl
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster

# 5. Deploy the app
kubectl create namespace retail-store
git clone https://github.com/aws-containers/retail-store-sample-app.git

# Deploy each service
helm install ui retail-store-sample-app/src/ui/chart --namespace retail-store
helm install catalog retail-store-sample-app/src/catalog/chart --namespace retail-store
helm install cart retail-store-sample-app/src/cart/chart --namespace retail-store
helm install orders retail-store-sample-app/src/orders/chart --namespace retail-store
helm install checkout retail-store-sample-app/src/checkout/chart --namespace retail-store

# 6. Wait for pods to be ready
kubectl get pods -n retail-store --watch

# 7. Make service accessible
kubectl patch svc ui -n retail-store -p '{"spec": {"type": "LoadBalancer"}}'

# 8. Get the URL
kubectl get svc ui -n retail-store -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'


What I Learned:
---------------

- Terraform is powerful. It helps to define infrastructure as code, version control it, re-use it,
- Kubernetes is complex - Pods, services, namespaces, RBAC (can get a little confusing),
- CI/CD eases the stress of manual deployments,
- Feature branches, PR reviews, versioning with GitFlow,
- Testing before deploying saves time (terraform plan and kubectl dry-run),

Useful Commands:
----------------
# Terraform
terraform fmt -recursive        # Fix formatting
terraform validate             # Check for errors
terraform state list           # See what's deployed
terraform destroy              # Delete everything

# Kubernetes
kubectl logs POD_NAME -f -n retail-store    # Follow logs in real-time
kubectl describe pod POD_NAME -n retail-store  # See pod details
kubectl exec -it POD_NAME -n retail-store -- /bin/bash  # SSH into a pod
kubectl get all -n retail-store  # See everything in a namespace

# Git
git log --oneline              # See commit history
git diff develop main          # Compare branches
git status                     # See what changed


# What's else I could add (and will eventually add in time):
- RDS databases (move from in-cluster to managed databases)
- ALB and Ingress
- SSL certificates to improve security
- Monitoring and logging
