identity_token "aws" {
  audience = ["<INSERT YOUR AUDIENCE HERE>"]
}

identity_token "k8s" {
  audience = ["k8s.workload.identity"]
}

locals {
  role_arn = "<INSERT YOUR ARN HERE>"
  tfc_kubernetes_audience = "k8s.workload.identity"
  tfc_hostname = "https://app.terraform.io"
  organization_name = "<INSERT HCP TERRAFORM ORG NAME>"
  eks_clusteradmin_arn = "arn:aws:iam::<INSERT AWS ACCOUNT NUMBER>:<INSERT ROLE NAME TO BE CREATED>"
  eks_clusteradmin_username = "<INSERT USERNAME TO BE CREATED>"
}

deployment "development" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = local.role_arn
    regions             = ["us-west-2"]
    vpc_name = "vpc-dev1"
    vpc_cidr = "10.0.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.30"
    cluster_name = "eksdev01"
    
    #EKS OIDC
    tfc_kubernetes_audience = local.tfc_kubernetes_audience
    tfc_hostname = local.tfc_hostname
    tfc_organization_name = local.organization_name
    eks_clusteradmin_arn = local.eks_clusteradmin_arn
    eks_clusteradmin_username = local.eks_clusteradmin_username

    #K8S
    k8s_identity_token = identity_token.k8s.jwt
    namespace = "hashibank"
  }
}

deployment "production" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = local.role_arn
    regions             = ["us-west-2", "us-east-1"]
    vpc_name = "vpc-prod1"
    vpc_cidr = "10.20.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.30"
    cluster_name = "eksprod01"
    
    #EKS OIDC
    tfc_kubernetes_audience = local.tfc_kubernetes_audience
    tfc_hostname = local.tfc_hostname
    tfc_organization_name = local.organization_name
    eks_clusteradmin_arn = local.eks_clusteradmin_arn
    eks_clusteradmin_username = local.eks_clusteradmin_username

    #K8S
    k8s_identity_token = identity_token.k8s.jwt
    namespace = "hashibank"

  }
}

deployment "disaster-recovery" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = local.role_arn
    regions             = ["us-east-1"]
    vpc_name = "vpc-dr1"
    vpc_cidr = "10.40.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.30"
    cluster_name = "eksdr01"
    
    #EKS OIDC
    tfc_kubernetes_audience = local.tfc_kubernetes_audience
    tfc_hostname = local.tfc_hostname
    tfc_organization_name = local.organization_name
    eks_clusteradmin_arn = local.eks_clusteradmin_arn
    eks_clusteradmin_username = local.eks_clusteradmin_username

    #K8S
    k8s_identity_token = identity_token.k8s.jwt
    namespace = "hashibank"

  }
}

# orchestrate "auto_approve" "safe_plans_dev" {
#  check {
#      # Only auto-approve in development environment if no resources are being removed
#      condition = context.plan.changes.remove == 0 && context.plan.deployment == deployment.development
#      reason = "Plan has ${context.plan.changes.remove} resources to be removed."
#  }
# }
