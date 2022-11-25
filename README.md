# Infrastructure Template for Hybrid Edge Workshop
This infrastructure template automates the requisite components for this hybrid edge workshop.

## Prerequsities
To run this infrastructure you must have:
1) Opted-in to the desired AWS Wavelength (defaults to `us-west-2-wl1-las-wlz-1`) and AWS Local Zones (defaults to `us-west-2-las-1a`). If you have not done so, please run the following:
```
aws ec2 modify-availability-zone-group —group-name us-west-2-las-1 —opt-in-status opted-in --region us-west-2
aws ec2 modify-availability-zone-group —group-name us-west-2-wl1 —opt-in-status opted-in --region us-west-2
```

2) Generated a Key Pair to use in the region (defaults to `us-west-2`). If you have not done so, please run the following:
```
aws ec2 create-key-pair --key-name test_key_uswest2 --query 'KeyMaterial' --output text > test_key_uswest2.pem
chmod 400 test_key_uswest2.pem
```

Should you choose to rename the key, please adjust the variable `worker_key_name` in the variables.tf file.

To run the infrastructure template, clone this repo and run the following:
```
git clone https://github.com/rhbelson/hyb303_infra_module.git
hyb303_infra_module
terraform init
terraform apply -auto-approve
```

After running this infrastructure template, you will get:
1) EC2 instance in the Parent Region (for Bastion Host)
1) EC2 instance in the Wavelength Zone for iPerf testing
2) EC2 instnace in the Local Zone for Pixel Streaming & WebRTC Streaming
3) Hybrid Edge (AZ/LZ/WLZ) EKS Cluster for MongoDB Lab

To view the IP addresses of your core infrastructure, take a look at the Terraform-generated outputs (see example):
```
Outputs:

local_zone_IP = "15.220.18.193"
bastion_ssh = "ssh -i -A test_key_uswest2.pem ec2-user@34.213.4.194"
my_ip_addr = "44.204.89.131"
local_zone_ssh = "ssh -i test_key_uswest2.pem ubuntu@15.220.18.193"
wavelength_zone_IP = "155.146.115.70"
wavelength_ssh = "ssh -i test_key_uswest2.pem ubuntu@10.0.10.50"
```


To configure the Amazon EKS cluster, export the locally-generated kubeconfig and view your nodes:
```
export KUBECONFIG=./kubeconfig_HYB-303-eks-Cluster
kubectl get nodes

Sample output:
Admin:~/environment/HYB_303/module_1_infra $ kubectl get nodes
NAME                                        STATUS   ROLES    AGE    VERSION
ip-10-0-1-92.us-west-2.compute.internal     Ready    <none>   113s   v1.21.2-eks-55daa9d
ip-10-0-10-195.us-west-2.compute.internal   Ready    <none>   42s    v1.21.2-eks-55daa9d
ip-10-0-2-125.us-west-2.compute.internal    Ready    <none>   2m7s   v1.21.2-eks-55daa9d
ip-10-0-20-77.us-west-2.compute.internal    Ready    <none>   62s    v1.21.2-eks-55daa9d
```

After running `kubectl get nodes`, you will see the following:
- Node in `us-west-2a` (10.0.1.92)
- Node in `us-west-2b` (10.0.2.125)
- Node in Las Vegas Wavelength Zone (10.0.10.195)
- Node in Las Vegas Local Zone (10.0.20.77)
