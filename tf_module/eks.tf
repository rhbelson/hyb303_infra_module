# data "aws_eks_cluster" "cluster" {
#   name = module.eks_cluster.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks_cluster.cluster_id
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token

#   experiments {
#     manifest_resource = true
#   }
# }


# data "http" "ip" {
#   url = "https://ifconfig.me/ip"
# }
# module "eks_cluster" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = var.cluster_name
#   version         = "17.24.0"
#   cluster_version = "1.23"
#   subnets         = [for subnet in aws_subnet.region_subnets : subnet.id]

#   vpc_id = aws_vpc.hyb303_vpc.id

#   manage_aws_auth              = true
#   manage_cluster_iam_resources = true
#   manage_worker_iam_resources  = true
  
#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true
#   cluster_endpoint_public_access_cidrs = ["${data.http.ip.response_body}/32"]
#   cluster_enabled_log_types = ["audit","api","authenticator"]
#   worker_create_security_group                       = true
#   worker_create_cluster_primary_security_group_rules = true
  
#   depends_on=[aws_instance.bastion_host_instance, aws_instance.webrtc_instance,aws_instance.iperf_instance]

#   write_kubeconfig = true

#   map_roles = [
#     {
#       rolearn  = aws_iam_role.worker_role.arn
#       username = "system:node:{{EC2PrivateDNSName}}"
#       groups   = ["system:bootstrappers", "system:nodes"]

#     }
#   ]
# }

# # Create VPC Endpoints for Private Access
# resource "aws_vpc_endpoint" "s3_gw_endpoint" {
#   vpc_id       = aws_vpc.hyb303_vpc.id
#   service_name = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type= "Gateway"
#   route_table_ids= [aws_route_table.WLZ_route_table.id]
#   tags = {
#     Name = "s3-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ec2_int_endpoint" {
#   vpc_id       = aws_vpc.hyb303_vpc.id
#   service_name = "com.amazonaws.${var.region}.ec2"  
#   private_dns_enabled = true
#   vpc_endpoint_type= "Interface"
#   subnet_ids = [aws_subnet.region_subnets["az1"].id,aws_subnet.region_subnets["az2"].id]
#   security_group_ids = [module.eks_cluster.cluster_primary_security_group_id]
#   tags = {
#     Name = "ec2-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_endpoint" {
#   vpc_id       = aws_vpc.hyb303_vpc.id
#   service_name = "com.amazonaws.${var.region}.ecr.api"  
#   private_dns_enabled = true
#   vpc_endpoint_type= "Interface"
#   subnet_ids = [aws_subnet.region_subnets["az1"].id,aws_subnet.region_subnets["az2"].id]
#   security_group_ids = [module.eks_cluster.cluster_primary_security_group_id]
#   tags = {
#     Name = "ecr-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
#   vpc_id       = aws_vpc.hyb303_vpc.id
#   service_name = "com.amazonaws.${var.region}.ecr.dkr"  
#   private_dns_enabled = true
#   vpc_endpoint_type= "Interface"
#   subnet_ids = [aws_subnet.region_subnets["az1"].id,aws_subnet.region_subnets["az2"].id]
#   security_group_ids = [module.eks_cluster.cluster_primary_security_group_id]
#   tags = {
#     Name = "ecr-dkr-endpoint"
#   }
# }




