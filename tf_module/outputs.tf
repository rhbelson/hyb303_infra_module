output "wavelength_zone_IP" {
  description = "Carrier IP address for Wavelength Zone modules for Pixel Streaming and MongoDB"
  value = aws_eip.wlz-ip["las"].carrier_ip
}

output "local_zone_IP" {
  description = "IP address for Local Zones modules for WebRTC streaming"
  value = aws_eip.localzones-ip["las"].public_ip
}

output "local_zone_ssh" {
  description = "Command to SSH into Local Zones Instance"
  value = "ssh -i ${var.worker_key_name}.pem ubuntu@${aws_eip.localzones-ip["las"].public_ip}"
}

output "bastion_ssh" {
  description = "Command to SSH into Bastion Host Instance"
  value = "ssh -i ${var.worker_key_name}.pem -A ec2-user@${aws_instance.bastion_host_instance.public_ip}"
}

output "wavelength_ssh" {
  description = "Command to SSH into Wavelength Zone Instance"
  value = "ssh ubuntu@${aws_instance.iperf_instance["las"].private_ip}"
}

output "vpc_id" {
  description = "ID of your Virtual Private Cloud (VPC)"
  value= aws_vpc.hyb303_vpc.id
}
output "region_subnet_1_id" {
  description = "ID of your 1st parent region subnet"
  value = aws_subnet.region_subnets["az1"].id
}
output "region_subnet_2_id" {
  description = "ID of your 2nd parent region subnet"
  value = aws_subnet.region_subnets["az2"].id
}



# output "my_ip_addr" {
#   value = local.ifconfig_co_json.ip
# }
