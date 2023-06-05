terraform {

required_providers {

  aws = {
    source  = "hashicorp/aws"
    version = "~> 4.4.0"
   }
 }
  required_version = ">= 1.1"

}
    provider "aws" {
 access_key = ""
  secret_key = ""
  region                   = "us-east-1"

   }





