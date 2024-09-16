# Terraform Code for creating a Cloud Run service with DB and Load balancer.

This repository contains Terraform code to set up a Google Cloud infrastructure with the following components:

- **Google Cloud Run Service**
- **Google Cloud SQL Database**
- **HTTP(S) Load Balancer**

## Configuration

### Variables



You need to provide configuration values for the Terraform deployment. You have several options for including these variables:

#### Option 1: `terraform.auto.tfvars`

Create a file named `terraform.auto.tfvars` in the root of your Terraform directory with the following content:

```
project_id = "my-project-id"
db_user    = "myuser"
db_pass    = "mypass"
db_name    = "mydb"
```


#### Option 2: CLI Variables

`terraform apply -var="project_id=my-project-id" -var="db_user=myuser" -var="db_pass=mypass" -var="db_name=mydb"`


#### Option 3: Integrating with Github Actions and using Secrets with CI/CD

