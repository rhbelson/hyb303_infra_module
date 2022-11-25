# Create AMI Mapping for WebRTC/AntMedia Host 
variable "webrtc_ami" {
  type = map(string)
  default = {
    "us-east-1" = "ami-094f380725f62923a"
    "us-west-2" = "ami-09e9eef2e7909b274"
  }
}

# Create AMI Mapping for iPerf Host
variable "iperf_ami" {
  type = map(string)
  default = {
    "us-east-1" = "ami-094f380725f62923a"
    "us-west-2" = "ami-09e9eef2e7909b274"
  }
}

# Create AMI Mapping for Wavelength Zone (Amazon Linux 2)
variable "bastion_ami" {
  type = map(string)
  default = {
    "us-east-1" = "ami-09d3b3274b6c5d4aa"
    "us-west-2" = "ami-0d593311db5abb72b"
  }
}

# data "http" "my_public_ip" {
#   url = "https://ifconfig.co/json"
#   request_headers = {
#     Accept = "application/json"
#   }
# }
# locals {
#   ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
# }

# Create Bastion Host
resource "aws_ebs_encryption_by_default" "default_encryption_rule" {
  enabled = true
}
resource "aws_instance" "bastion_host_instance" {
  ami                         = lookup(var.bastion_ami, var.region)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.region_subnets["az1"].id
  key_name                    = var.worker_key_name
  security_groups             = [aws_security_group.bastion_security_group.id]
  associate_public_ip_address = true
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required" 
  }
  tags = {
    Name = "wavelength-bastion-host"
  }
}

# Create bastion host
resource "aws_security_group" "bastion_security_group" {
  vpc_id      = aws_vpc.hyb303_vpc.id
  name        = "bastion-sg"
  description = "Security group for bastion host EC2 instance"
  ingress {
    # cidr_blocks = ["${local.ifconfig_co_json["ip"]}/32"]
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}

# Create security group for WebRTC resources
resource "aws_security_group" "webrtc_security_group" {
  vpc_id      = aws_vpc.hyb303_vpc.id
  name        = "webrtc-sg"
  description = "Security group for WebRTC Local Zones resources"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  ingress {
    security_groups = [aws_security_group.bastion_security_group.id]
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
  }
   ingress {
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "webrtc-sg"
  }
}


# Create EC2 instance in Local Zone
# resource "aws_instance" "pixelstreaming_instance" {
#   for_each        = var.local_zones
#   ami             = lookup(var.webrtc_ami, var.region)
#   instance_type   = "t3.xlarge" #r5.2xlarge another option
#   subnet_id       = aws_subnet.localzones_subnets[each.key].id
#   key_name        = var.worker_key_name
#   security_groups = [aws_security_group.webrtc_security_group.id]
#   metadata_options {
#     http_endpoint               = "enabled"
#     http_put_response_hop_limit = 2
#     http_tokens                 = "required" 
#   }
#   tags = {
#     Name = "HYB303-module2-webrtc-localzones"
#   }
# }

# # Create IP address in Local Zones NBG
# resource "aws_eip" "localzones-ip" {
#   for_each             = var.local_zones
#   vpc                  = true
#   network_border_group = var.local_zones[each.key].network_border_group
# }

# # Attach IP address to Local Zones instance
# resource "aws_eip_association" "localzones_eip_assoc" {
#   for_each      = var.local_zones
#   instance_id   = aws_instance.webrtc_instance[each.key].id
#   allocation_id = aws_eip.localzones-ip[each.key].id
# }

#---------------------------------------------------------------

# Create EC2 instance in Wavelength Zone
resource "aws_instance" "webrtc_instance" {
  for_each        = var.wavelength_zones
  ami             = lookup(var.webrtc_ami, var.region)
  instance_type   = "t3.medium"
  subnet_id       = aws_subnet.wavelength_subnets[each.key].id
  key_name        = var.worker_key_name
  security_groups = [aws_security_group.webrtc_security_group.id]
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required" 
  }
  tags = {
    Name = "HYB303-webrtc-iperf"
  }
}
# Create IP address in Wavelength Zones NBG
resource "aws_eip" "wlz-ip" {
  for_each             = var.wavelength_zones
  vpc                  = true
  network_border_group = var.wavelength_zones[each.key].availability_zone
}

# Attach IP address to Wavelength Zones instance
resource "aws_eip_association" "wavelengthzones_eip_assoc" {
  for_each      = var.wavelength_zones
  instance_id   = aws_instance.webrtc_instance[each.key].id
  allocation_id = aws_eip.wlz-ip[each.key].id
}