provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

locals {
  cluster_name = "gcd-eks"
  tags         = {
    CreatedBy = "Terraform"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name                   = local.cluster_name
  cluster_version                = 1.28
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  manage_aws_auth_configmap = true

  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    instance_types             = ["t3.medium"]
    capacity_type              = "SPOT"
    iam_role_attach_cni_policy = true
    use_name_prefix            = false
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 30
          volume_type           = "gp3"
          delete_on_termination = true
        }
      }
    }
  }

  eks_managed_node_groups = {
    gcd-eks-app-ng = {
      name         = "${local.cluster_name}-app-ng"
      labels       = { nodegroup = "app" }
      desired_size = 2
      min_size     = 2
      max_size     = 2
    }
  }
}