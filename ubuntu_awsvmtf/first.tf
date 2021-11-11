terraform { 
    required_version = "~>v1.0.0" 
    required_providers { 
        aws = {
            source = "hashicorp/aws"
        }
    } 
} 

# Configure the Amazon WebServices Provider
provider "aws" {
#    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#    client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#    client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#    tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    region = "us-west-2"
}

variable resource_location { 
    type = string 
    description = "AWS region for hosting resources" 
} 

resource "aws_instance" "helloworld" { 
    #ami           = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*" 
    # Canonical ami for 20.04 / ARM64
    ami = "ami-0327b24ad9181634e"
    instance_type = "t4g.micro" 
    tags = { 
        Name = "Graviton" 
    } 
} 

