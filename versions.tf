terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "aws" {
  region = jsondecode(data.local_file.region.content)["region"]
}

data "local_file" "region" {
  filename = "${path.module}/config.json"
}