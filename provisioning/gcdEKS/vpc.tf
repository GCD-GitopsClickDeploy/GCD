module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gcd-vpc"
  cidr = "192.168.0.0/16"

  azs              = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets   = ["192.168.0.0/20", "192.168.16.0/20"]
  public_subnet_names = ["devops-pub-a-sn", "devops-pub-c-sn"]
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

resource "aws_security_group" "gcd_sg" {
  name        = "devops-security-group"
  description = "Security group for gcd VPC"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gcd VPC Security Group"
  }
}

resource "aws_security_group_rule" "nodeport_access" {
  type        = "ingress"
  from_port   = 30000
  to_port     = 32767
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.gcd_sg.id
}

