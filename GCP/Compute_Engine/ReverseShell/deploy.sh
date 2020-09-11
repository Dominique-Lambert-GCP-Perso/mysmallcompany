#!/bin/bash
project="data-flow-test-dla"


echo "Enable API"
#gcloud services enable dataflow.googleapis.com pubsub.googleapis.com datacatalog.googleapis.com bigqueryconnection.googleapis.com
gcloud services list

echo "Compute Engine : Création de la VM"
gcloud beta compute --project=$project instances create reverse-shell-server --zone=europe-west1-b --machine-type=e2-micro --subnet=default --network-tier=PREMIUM --no-restart-on-failure --maintenance-policy=TERMINATE --preemptible --service-account=220526071536-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --image=centos-7-v20200910 --image-project=centos-cloud --boot-disk-size=20GB --boot-disk-type=pd-standard --boot-disk-device-name=reverse-shell-server --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

echo "FireWall"
gcloud compute --project=$project firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

echo "Fin"