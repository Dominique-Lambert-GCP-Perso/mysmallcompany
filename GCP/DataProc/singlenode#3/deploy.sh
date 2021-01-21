#!/bin/bash

echo "Cloud storage : Création des bucket"
gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla
gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla-temp

echo "Création des réseaux et sous-réseaux"
gcloud compute networks create vpc-dataproc --project=data-proc-test-dla --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create subnet-dataproc --project=data-proc-test-dla --range=10.0.0.0/9 --network=vpc-dataproc --region=europe-west1 --enable-private-ip-google-access

echo "Création des régles de FireWall"
gcloud compute --project=data-proc-test-dla firewall-rules create vpc-dataproc-allow-internal --direction=INGRESS --priority=1000 --network=vpc-dataproc --action=ALLOW --rules=udp:0-65535,tcp:0-65535,icmp --source-ranges=10.0.0.0/9
gcloud compute --project=data-proc-test-dla firewall-rules create vpc-dataproc-allow-ssh --direction=INGRESS --priority=1000 --network=vpc-dataproc --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

echo "Création du cluster"
#gcloud dataproc clusters create cluster-dataproc-dla --optional-components=ANACONDA,DRUID,ZOOKEEPER,HBASE,HIVE_WEBHCAT,JUPYTER --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet subnet-dataproc --no-address --zone europe-west1-b --single-node --master-machine-type n1-standard-1 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla
#gcloud dataproc clusters create cluster-dataproc-dla --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet subnet-dataproc --no-address --zone europe-west1-b --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla
gcloud dataproc clusters create cluster-dataproc-dla --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet subnet-dataproc --zone europe-west1-b --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla

echo "Fin"
