# Credentials and Sensitive Data

# How to Secure Crendentials and sensitive data (Not shared with git repositories)
# 2 wways to use crendetials with Terraform

# 1) Set credentials as Environment variables : > export AWS_SECRET_ACCESS_KEY=..
#                                               > export AWS_ACCESS_KEY=.. then > terraform apply => works
# !!!!!!!!! Only available in this context(terminal)
# We can get the desired environment variables for all providers in Terraform Documentations


# 2) Globaly config: using ~/.aws/credentials
#  > aws configure .. 
#    Configured only once and then Terraform will recognize them


############################################################################################

# Environment variables for Terraform (Customs to Terraform)

# > export TF_VAR_avail_zone="eu-west-3"
# In Main.tf
# variable "avail_zone" {}
# refernece it : var.avail_zone
# !!!! Terraform will automatically fetch Env variables TF_VAR_..


###########################################################################################

# Assign variable value:

# 1) > terraform apply (prompt to enter value)

# 2) > terraform apply -var "name_var=value_var"

# 3) Most efficient and correct way : Using variables file
#       - The default name of file : terraform.tfvars  > terraform apply
#         If we use other file name *.tfvars > terraform -var-file filename.tfvars apply

# Note: We can assign a default value for each variable, to let Terraform use them if it doesn't find a value of variable.
#       We have different type of value: type = string, list, list(object), list(string), list, int, boolean ...

variable "cidr_blocks" { 
    description = "cidr blocks and name for vpc and subnets" 
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable "aws_region" { description = "aws region"}
variable "aws_access_key" { description = "aws access key"}
variable "aws_secret_key" { description = "aws secret key"}



provider "aws" {}

resource "aws_vpc" "devops_vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name = var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "devops-subnet-1" {
  vpc_id = aws_vpc.devops_vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "eu-west-3a"
  tags = {
    Name: var.cidr_blocks.name
  }
}






###################################################################

# Using Data
# Getting data from existing resources on aws by choosing a criteria


/*
data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "subnet-dev-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "..."
    availability_zone = "..."
}
*/


# Using Output
# Output are  like function return values
# What values we want Terrform to echo after apply configurations from one of the resources

/*
output "devops-vpc-id" {
    value = aws_vpc.devops_vpc.id
}
...  
} 
*/

