This is the IaC code to create Cloud run service  with database CLOUD SQL and Load balancer .

You need to add either terraform.auto.tfvars

to include in the variables like this


project_id = "my-project-id"
db_user="myuser"
db_pass="mypass"
db_name="mydb"


OR 

you can include them via CLI 

or if you are including a Github Actions CI/CD pipeline you can include it in the Github Actions Secrets.