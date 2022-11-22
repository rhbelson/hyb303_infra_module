variable "profile" {
  type        = string
  description = "AWS Credentials Profile to use"
  default     = "default"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "This is the AWS region."
  validation {
    condition     = contains(["us-east-1", "us-west-2"], var.region)
    error_message = "Valid values for regions supporting Wavelength Zones are us-east-1 and us-west-2."
  }
}

variable "worker_key_name" {
  type        = string
  default     = "test_key_uswest2"
  description = "This is your EC2 key name."
}

variable "cluster_name" {
  type        = string
  default     = "HYB-303-eks-Cluster"
  description = "This is the name of your EKS cluster deployed to the parent region."
}

variable "wavelength_zones" {
  description = "This is the metadata for your Wavelength Zone subnets."
  default = {
    las = {
      availability_zone    = "us-west-2-wl1-las-wlz-1",
      availability_zone_id = "usw2-wl1-las-wlz1",
      worker_nodes         = 1,
      cidr_block           = "10.0.10.0/24"
    },
    # lax = {
    #   availability_zone = "us-west-2-wl1-lax-wlz-1",
    #   availability_zone_id = "usw2-wl1-lax-wlz1",
    #   worker_nodes = 1,
    #   cidr_block = "10.0.11.0/24"
    # },
  }
}

variable "local_zones" {
  description = "This is the metadata for your Local Zone subnets."
  default = {
    las = {
      availability_zone    = "us-west-2-las-1a",
      network_border_group = "us-west-2-las-1"
      availability_zone_id = "usw2-las1-az1",
      worker_nodes         = 0,
      cidr_block           = "10.0.20.0/24"
    },
    # lax = {
    #   availability_zone = "us-west-2-wl1-lax-wlz-1",
    #   availability_zone_id = "usw2-wl1-lax-wlz1",
    #   worker_nodes = 1,
    #   cidr_block = "10.0.11.0/24"
    # },
  }
}

variable "availability_zones" {
  description = "This is the metadata for your parent region subnets."
  default = {
    az1 = {
      availability_zone_id = "usw2-az1"
      cidr_block           = "10.0.1.0/24"
    },
    az2 = {
      availability_zone_id = "usw2-az2"
      cidr_block           = "10.0.2.0/24"
    }
  }
}

variable "node_group_s3_bucket_url" {
  type        = string
  default     = "https://wavelengthtutorials.s3.amazonaws.com/wlz-eks-node-group.yaml"
  description = "This is the S3 object URL of the EKS node group with auto-attached Carrier IPs."
}

variable "worker_volume_size" {
  default     = 20
  description = "This is the volume size (GB) of the EBS volumes for the EKS worker nodes."
}

variable "worker_instance_type" {
  default = "t3.medium"
  validation {
    condition     = contains(["t3.medium", "t3.xlarge", "r5.2xlarge", "g4dn.2xlarge"], var.worker_instance_type)
    error_message = "Valid values for instance types are t3.medium, t3.xlarge, r5.2xlarge, and g4dn.2xlarge."
  }
  description = "This is the EC2 instance type for the EKS worker nodes."
}


# Create AMI Mapping for Wavelength Zone (EKS 1.21)
variable "worker_image_id" {
  description = "This is the AMI ID for the EKS-optimized AMI."
  type        = map(string)
  default = {
    "us-east-1" = "ami-0595cbb9fda4ac83b"
    "us-west-2" = "ami-06ed5fde5f1625f5b"
  }
}

variable "worker_nodegroup_name" {
  default     = "Wavelength-Node-Group"
  description = "This is the name for the EKS worker nodes."
}

locals {
  ports_in = [
    443,
    80,
    22
  ]
  ports_out = [
    0
  ]
}
