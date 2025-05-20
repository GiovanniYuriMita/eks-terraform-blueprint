terraform {
  backend "s3" {
    bucket = "ream-eks-tf-state"
    key = "eks.tfstate"
    region = "us-east-1"
  }
}