# terraform-lambda-fixed-ip
Provide a fixed IP (ElasticIP) to your AWS Lambdas.

This is extremely useful when you need to connect to a service that filters IPs. Tipical services use firewalls that whitelist some IPs, by including your ElasticIP on the firewall you will be able to connect to the service from your Lambda.

## How it works
 - This terraform code creates a VPC in the eu-west-1 region (you can modify it)
 - Creates a public and a private networks
 - Routes all the traffic from the private network to the public network
 - Routes all the traffic from the public network to internet
 - Assigns an elastic IP to the traffic coming from the public network, so it has a fixed IP
 
 ## How to use it
  - Plan terraform to see what is going to do: `terraform plan`
  - If you like what you see, apply the changes: `terraform apply`
  - Create your Lambdas inside the <b>private</b> subnet
  - When your Lambdas run they will have your ElasticIP (and it will always be the same if you don't change it).
  
  ## Dependencies
   - Terraform == 0.9.x , you can download it from [terraform downloads](https://www.terraform.io/downloads.html)
   - AWS account
