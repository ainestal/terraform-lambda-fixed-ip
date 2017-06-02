# terraform-lambda-fixed-ip
Provide a fixed IP (ElasticIP) to your AWS Lambdas.

This is extremely useful when you need to connect to a service that filters IPs. Typical services use firewalls that can whitelist some IPs, by allowing your ElasticIP in the firewall rules you will be able to connect to the service from your Lambda.


## How it works
 - This terraform module creates a VPC in the eu-west-1 region (you can use a different region)
 - Creates a public and a private networks
 - Routes all the traffic from the private network to the public network
 - Routes all the traffic from the public network to internet
 - Assigns an elastic IP to the traffic coming from the public network, so it has a fixed IP
 
 
 ## How to use it
  - Include this module in your code: 
```
module "lambdas_vpc" {
    source  = "github.com/ainestal/terraform-lambda-fixed-ip?ref=0.2"
}
```
  - Plan terraform to see what is going to do:
```
terraform plan
```
  - If you like what you see, apply the changes:
```
terraform apply
```
  - Create your Lambdas inside the <b>private</b> subnet.
  - You can reference the vpc_id and the elastic ip id. If you are terraforming your lambda, the [lambda_function example](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) would look like: 
```
resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda_function_name"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "exports.test"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "nodejs4.3"

  environment {
    variables = {
      foo = "bar"
    }
  }
  
  // Include this Lambda in the VPC that provides a Elastic IP
  vpc_config {
    subnet_ids = [ ${module.lambdas_vpc.private_subnet_id} ]

    security_group_ids = [ <THE ID OF YOUR SECURITY GROUP> ]
  }
}
```
  - When your Lambdas run they will use your ElasticIP (and it will always be the same if you don't change it).
 
 
  ## Dependencies
   - Terraform >= 0.9.x , you can download it from [terraform downloads](https://www.terraform.io/downloads.html)
   - AWS account
