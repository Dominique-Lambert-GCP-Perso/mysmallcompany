#!/bin/bash
#gcloud compute networks create vpn-network-1 --subnet-mode=custom

#gcloud compute networks subnets create subnet-a --network=vpn-network-1 --region=us-west1 --range=10.1.1.0/24

#gcloud compute firewall-rules create icmp-tcp22-allow-1 --direction=INGRESS --priority=1000 --network=vpn-network-1 --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0

#gcloud compute networks create vpn-network-2 --subnet-mode=custom

#gcloud compute networks subnets create subnet-b --network=vpn-network-2 --region=us-central1 --range=10.1.2.0/24

#gcloud compute networks subnets create subnet-c --network=vpn-network-2 --region=us-east1 --range=10.1.3.0/24

#gcloud compute firewall-rules create icmp-tcp22-allow-2 --direction=INGRESS --priority=1000 --network=vpn-network-2 --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0

#gcloud beta compute instances create "vpn-1-a" --zone "us-west1-a" --machine-type "f1-micro" --subnet "subnet-a" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "vpn-1-a"

#gcloud beta compute instances create "vpn-2-b" --zone "us-central1-c" --machine-type "f1-micro" --subnet "subnet-b" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "vpn-2-b"

#gcloud beta compute instances create "vpn-2-c" --zone "us-east1-d" --machine-type "f1-micro" --subnet "subnet-c" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "vpn-2-c"

#gcloud compute addresses create vpn-static-1 --region=us-west1

#gcloud compute addresses create vpn-static-2 --region=us-central1

# Créattion du VPN dans le subnet-a
gcloud compute --project "msc-network-tests" target-vpn-gateways create "vpn-gateway-1" --region "us-west1" --network "vpn-network-1"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-1-rule-esp" --region "us-west1" --address "35.230.109.6" --ip-protocol "ESP" --target-vpn-gateway "vpn-gateway-1"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-1-rule-udp500" --region "us-west1" --address "35.230.109.6" --ip-protocol "UDP" --ports "500" --target-vpn-gateway "vpn-gateway-1"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-1-rule-udp4500" --region "us-west1" --address "35.230.109.6" --ip-protocol "UDP" --ports "4500" --target-vpn-gateway "vpn-gateway-1"
gcloud compute --project "msc-network-tests" vpn-tunnels create "vpn-gateway-1-tunnel-1" --region "us-west1" --peer-address "35.239.160.55" --shared-secret "Password" --ike-version "2" --local-traffic-selector "10.1.1.0/24" --target-vpn-gateway "vpn-gateway-1"
gcloud compute --project "msc-network-tests" routes create "vpn-gateway-1-tunnel-1-route-1" --network "vpn-network-1" --next-hop-vpn-tunnel "vpn-gateway-1-tunnel-1" --next-hop-vpn-tunnel-region "us-west1" --destination-range "10.1.2.0/24"
gcloud compute --project "msc-network-tests" routes create "vpn-gateway-1-tunnel-1-route-2" --network "vpn-network-1" --next-hop-vpn-tunnel "vpn-gateway-1-tunnel-1" --next-hop-vpn-tunnel-region "us-west1" --destination-range "10.1.3.0/24"
 
# Créattion du VPN dans le subnet-b
gcloud compute --project "msc-network-tests" target-vpn-gateways create "vpn-gateway-2" --region "us-central1" --network "vpn-network-2"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-2-rule-esp" --region "us-central1" --address "35.239.160.55" --ip-protocol "ESP" --target-vpn-gateway "vpn-gateway-2"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-2-rule-udp500" --region "us-central1" --address "35.239.160.55" --ip-protocol "UDP" --ports "500" --target-vpn-gateway "vpn-gateway-2"
gcloud compute --project "msc-network-tests" forwarding-rules create "vpn-gateway-2-rule-udp4500" --region "us-central1" --address "35.239.160.55" --ip-protocol "UDP" --ports "4500" --target-vpn-gateway "vpn-gateway-2"
gcloud compute --project "msc-network-tests" vpn-tunnels create "vpn-gateway-2-tunnel-1" --region "us-central1" --peer-address "35.230.109.6" --shared-secret "Password" --ike-version "2" --local-traffic-selector "10.1.2.0/24" --target-vpn-gateway "vpn-gateway-2"
gcloud compute --project "msc-network-tests" routes create "vpn-gateway-2-tunnel-1-route-1" --network "vpn-network-2" --next-hop-vpn-tunnel "vpn-gateway-2-tunnel-1" --next-hop-vpn-tunnel-region "us-central1" --destination-range "10.1.1.0/24"


echo "SCRIPT HAS FINISHED RUNNING. PROCEED WITH THE EXERCISE"
