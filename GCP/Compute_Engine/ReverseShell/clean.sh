#!/bin/bash
project="data-flow-test-dla"

echo "compute engine : delete instance"
gcloud beta compute --project=$project instances delete --zone=europe-west1-b reverse-shell-server

echo "delete FireWall rules, subnet and VPC"
gcloud compute --project=$project firewall-rules delete default-allow-http
echo "Fin"
