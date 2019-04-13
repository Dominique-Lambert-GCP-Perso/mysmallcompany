#!/bin/bash

echo "delete instances"
gcloud -q compute instances delete "vpn-1-a" --zone "us-west1-a"
gcloud -q compute instances delete "vpn-2-b" --zone "us-central1-c"
gcloud -q compute instances delete "vpn-2-c" --zone "us-east1-d"

echo "delete tunnels and getway 1"
gcloud -q compute forwarding-rules delete "vpn-gateway-1-rule-esp" --region "us-west1"
gcloud -q compute forwarding-rules delete "vpn-gateway-1-rule-udp500" --region "us-west1"
gcloud -q compute forwarding-rules delete "vpn-gateway-1-rule-udp4500" --region "us-west1"
gcloud -q compute vpn-tunnels delete "vpn-gateway-1-tunnel-1" --region "us-west1"
gcloud -q compute target-vpn-gateways delete "vpn-gateway-1" --region "us-west1"

echo "delete tunnels and getway 2"
gcloud -q compute forwarding-rules delete "vpn-gateway-2-rule-esp" --region "us-central1"
gcloud -q compute forwarding-rules delete "vpn-gateway-2-rule-udp500" --region "us-central1"
gcloud -q compute forwarding-rules delete "vpn-gateway-2-rule-udp4500" --region "us-central1"
gcloud -q compute vpn-tunnels delete "vpn-gateway-2-tunnel-1" --region "us-central1" 
gcloud -q compute target-vpn-gateways delete "vpn-gateway-2" --region "us-central1"

echo "delete routers 1 and 2"
gcloud -q compute routers delete "vpn-router-1" --region "us-west1"
gcloud -q compute routers delete "vpn-router-2" --region "us-central1"

echo "delete firewall-rules, subnets and network 1"
gcloud -q compute firewall-rules delete "icmp-tcp22-allow-1"
gcloud -q compute networks subnets delete "subnet-a" --region "us-west1"
gcloud -q compute networks delete "vpn-network-1"

echo "delete firewall-rules, subnets and network 2"
gcloud -q compute firewall-rules delete "icmp-tcp22-allow-2"
gcloud -q compute networks subnets delete "subnet-b" --region "us-central1"
gcloud -q compute networks subnets delete "subnet-c" --region "us-east1"
gcloud -q compute networks delete "vpn-network-2"

