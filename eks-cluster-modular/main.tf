variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "devsecops-eks"
}

module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  cluster_name = var.cluster_name
}

module "nodegroup" {
  source = "./modules/nodegroup"

  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.public_subnet_ids
  node_role_arn = module.eks.node_role_arn
  node_sg_id     = module.security_group.node_sg_id
  ssh_key_name  = var.ssh_key_name
}

module "security_group" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  cluster_name = var.cluster_name
  
  depends_on = [module.eks]
}

resource "null_resource" "wait_for_eks" {
  depends_on = [
    module.eks,
    module.nodegroup  # ✅ CORRECT : nodegroup est un module indépendant
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

module "eks_monitoring" {
  source = "./modules/eks-monitoring"
  
  cluster_name                     = module.eks.cluster_name
  cluster_endpoint                 = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  oidc_provider_arn                 = module.eks.oidc_provider_arn

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [null_resource.wait_for_eks]
}