module "my_vpc" {
  source = "./modules/network"

  cidr_block_public  = var.cidr_block_public
  cidr_block_private = var.cidr_block_private
  availability_zone  = var.availability_zone
}

provider "aws" {
  region = var.aws_region
}
