
echo "delete instances"
gcloud compute instances delete vpn-1-a --zone=us-west1-a
gcloud compute instances delete vpn-2-b --zone=us-central1-c
gcloud compute instances delete vpn-2-c --zone=us-east1-d

echo "delete tunnels and getway 1"
gcloud compute vpn-tunnels delete vpn-gateway-1-tunnel-1
gcloud compute target-vpn-gateways delete vpn-gateway-1

echo "delete tunnels and getway 2"
gcloud compute vpn-tunnels delete vpn-gateway-2-tunnel-1
gcloud compute target-vpn-gateways delete vpn-gateway-2

echo "delete touters 1 and 2"
gcloud compute routers delete vpn-router-1
gcloud compute routers delete vpn-router-2

echo "delete firewall-rules, subnets and network 1"
gcloud compute firewall-rules delete icmp-tcp22-allow-1
gcloud compute networks subnets delete subnet-a
gcloud compute networks create vpn-network-1

echo "delete firewall-rules, subnets and network 2"
gcloud compute firewall-rules delete icmp-tcp22-allow-2
gcloud compute networks subnets delete subnet-b
gcloud compute networks subnets delete subnet-c
gcloud compute networks create vpn-network-2

