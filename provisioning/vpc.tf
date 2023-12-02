module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gcd-vpc"
  cidr = "192.168.0.0/16"

  azs              = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets   = ["192.168.0.0/20", "192.168.16.0/20"]
  public_subnet_names = ["gcd-pub-a-sn", "gcd-pub-c-sn"]
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1  
    "kubernetes.io/cluster/gcd-eks" = "gcd-eks"
  }

  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true
  map_public_ip_on_launch = true

  tags = {
    CreatedBy = "Terraform"
  }
}