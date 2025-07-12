terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }
  backend "s3" {
    bucket = "devops-aws-remote-state"
    key    = "jenkins"
    region = "us-east-1"
    dynamodb_table = "DevOps-Practice"
  } 
} 

provider "aws" {
  # Configuration options
  region = "us-east-1"
}