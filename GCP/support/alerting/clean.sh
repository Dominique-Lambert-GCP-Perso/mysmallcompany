#!/bin/bash

policie_name=$(gcloud alpha monitoring policies list --filter="displayName: CPU Utilisation for lamp-1-VM" --format="value(name)")
echo "Delete policie : name ($policie_name) "
gcloud alpha monitoring policies delete $policie_name

pubsub_channel_name=$(gcloud alpha monitoring channels list --filter='type="pubsub"' --format="value(name)")
echo "Delete channel de notification : name ($pubsub_channel_name)"
gcloud alpha monitoring channels delete $pubsub_channel_name

echo "Delete de la subscription PubSub"
gcloud pubsub subscriptions delete alerts-sub

echo "Delete du topic PubSub : alerts-tp"
gcloud pubsub topics delete alerts-tp

echo "delete vm"
gcloud compute instances delete lamp-1-vm --zone=europe-west1-b

echo "delete buckets"

echo "delete FireWall rules, subnet and VPC"
gcloud compute --project=data-proc-test-dla firewall-rules delete default-allow-http
gcloud compute --project=data-proc-test-dla firewall-rules delete default-allow-https

echo "Fin"