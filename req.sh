# Multiple virtual machines

ansible
  e2-medium
  us-central1-a
  i27-ecommerce-central-subnet
jenjins-master
  e2-medium
  us-east4-a
  i27-ecommerce-east-subnet
jenkins-slave
  n1-standard-4
  us-east4-a
  i27-ecommerce-east-subnet

# TASK 1
i27-iac(folder)
  main.tf
  variables.tf
  terraform.tfvars
  modules(folder)
    networks(folder)
      main.tf
      variables.tf
      outputs.tf
    compute(folder)
      main.tf
      variables.tf
      outputs.tf  
