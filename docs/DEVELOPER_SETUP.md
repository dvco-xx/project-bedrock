# Developer Setup Guide

This guide helps developers configure access to the Project Bedrock EKS cluster.

## Prerequisites

- AWS CLI installed and configured
- kubectl installed
- Developer credentials from your administrator

## Step 1: Configure AWS CLI

```bash
aws configure

# When prompted, enter:
AWS Access Key ID: [your access key from credentials file]
AWS Secret Access Key: [your secret key from credentials file]
Default region name: us-east-1
Default output format: json
```

## Step 2: Update kubeconfig

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster

# Verify connection
kubectl cluster-info
```

## Step 3: Verify Your Access

```bash
# These commands should work (read access)
kubectl get pods -n retail-store
kubectl get svc -n retail-store
kubectl logs -l app.kubernetes.io/name=ui -n retail-store

# These commands should FAIL (no write access)
kubectl delete pod <pod-name> -n retail-store
# Expected: Error: pods "..." is forbidden...
```

## What You Can Do (Read-Only Access)

**Allowed:**

- View pods and their logs
- Describe resources
- List deployments, services, configmaps
- Watch events
- Access multiple namespaces

**Not Allowed:**

- Create or delete resources
- Modify deployments
- Scale applications
- Change configurations
- Delete pods or services

## Common Commands

```bash
# View pods
kubectl get pods -n retail-store
kubectl describe pod <pod-name> -n retail-store

# View logs
kubectl logs <pod-name> -n retail-store
kubectl logs -f <pod-name> -n retail-store  # follow logs

# View services
kubectl get svc -n retail-store
kubectl describe svc <service-name> -n retail-store

# View deployments
kubectl get deployments -n retail-store
kubectl describe deployment <deployment-name> -n retail-store

# View all resources
kubectl get all -n retail-store

# Watch real-time changes
kubectl get pods -n retail-store --watch
```

## Troubleshooting

### "error: You must be logged in to the server"

Your credentials are incorrect or expired. Run:

```bash
aws configure
# Re-enter your credentials
```

### "Error from server (Forbidden): pods is forbidden"

Your IAM user doesn't have access. Contact your administrator.

### "The connection to the server was refused"

The cluster might be down or you're in the wrong region. Verify:

```bash
aws eks describe-cluster \
  --name project-bedrock-cluster \
  --region us-east-1
```
