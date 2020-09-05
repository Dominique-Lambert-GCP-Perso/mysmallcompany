#!/bin/bash

echo "delete cluster"
gcloud dataproc clusters delete cluster-dataproc-dla --region europe-west1

echo "delete buckets"
gsutil rm -r gs://cs-for-dataproc-dla
gsutil rm -r gs://cs-for-dataproc-dla-temp

echo "delete FireWall rules, subnet and VPC"
gcloud compute --project=data-proc-test-dla firewall-rules delete vpc-dataproc-allow-internal
gcloud compute --project=data-proc-test-dla firewall-rules delete vpc-dataproc-allow-ssh
gcloud compute networks subnets delete subnet-dataproc --project=data-proc-test-dla
gcloud compute networks delete vpc-dataproc --project=data-proc-test-dla

echo "Fin"