import random, json, requests, sys, argparse
from vz_edge_discovery import VzEdgeDiscovery

# Create arg parser to enable following syntax: python3 edsSetup.py --carrier_ips $carrier_ips --wlzs $wlzs
parser = argparse.ArgumentParser(description='EDS configuration')
parser.add_argument('--carrier_ips', action="store", dest='carrier_ips', default = "")
parser.add_argument('--wlzs', action="store", dest='wlzs', default = "")
args = parser.parse_args()

"""
Step 0: Filter input to create variables for service endpoints
"""
carrierIpAddresses=args.carrier_ips.split("\t")
wavelengthZones=args.wlzs.split("\t")
fqdns=[]
endpointIds=[]
for w in wavelengthZones:
    fqdns.append(str(w[14:16])+"application.service.com")
    endpointIds.append(str("endpoint_")+str(w[14:16])+str(random.randint(1,1000)))

"""
Step 1: Authenticate to Verizon Edge Discovery Service
"""
eds = VzEdgeDiscovery()
access_token=eds.authenticate(
    app_key="<your-app-key>",
    secret_key="<your-secret-key>")

"""
Step 2: Generate Service Profile
"""
serviceProfileId=eds.create_service_profile(
    access_token=access_token,
    max_latency=40)

"""
Step 3: Create Service Registry
"""
my_service_endpoints_id=eds.create_service_registry(
    access_token = access_token,
    service_profile_id = serviceProfileId,
    carrier_ips = carrierIpAddresses,
    availability_zones = wavelengthZones,
    application_id=endpointIds,
    fqdns=fqdns)
