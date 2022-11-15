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
  value = "ssh -i -A ${var.worker_key_name}.pem ec2-user@${aws_instance.bastion_host_instance.public_ip}"
}

output "wavelength_ssh" {
  description = "Command to SSH into Wavelength Zone Instance"
  value = "ssh -i ${var.worker_key_name}.pem ubuntu@${aws_instance.iperf_instance["las"].private_ip}"
}

# output "my_ip_addr" {
#   value = local.ifconfig_co_json.ip
# }