#!/bin/bash
source param.sh

policie_name=$(gcloud alpha monitoring policies list --project=$project_id --filter="displayName: CPU Utilisation for lamp-1-VM" --format="value(name)")
if [ "$policie_name" != "" ] 
then
    echo "Delete policie : name ($policie_name) "
    gcloud alpha monitoring policies delete $policie_name
fi

pubsub_channel_name=$(gcloud alpha monitoring channels list --project=$project_id --filter='type="pubsub"' --format="value(name)")
if [ "$pubsub_channel_name" != "" ] 
then
    echo "Delete channel de notification : name $pubsub_channel_name"
    gcloud alpha monitoring channels delete $pubsub_channel_name
fi

alerts_notification_bem_email=$(gcloud iam service-accounts list --project=$project_id --filter="displayName: alerts-notification-bem" --format="value(email)")
if [ "$alerts_notification_bem_email" != "" ] 
then
    echo "Delete service account : name (alerts-notification-bem)"
    gcloud iam service-accounts delete $alerts_notification_bem_email
fi

echo "Delete de la subscription PubSub"
gcloud pubsub subscriptions delete --project=$project_id $pubsub_subscription_name

echo "Delete du topic PubSub : alerts-tp"
gcloud pubsub topics delete --project=$project_id $pubsub_topic_name

echo "delete vm"
gcloud compute instances delete --project=$project_id lamp-1-vm --zone=europe-west1-b

echo "delete buckets"

echo "delete FireWall rules, subnet and VPC"
gcloud compute --project=$project_id firewall-rules delete default-allow-http
gcloud compute --project=$project_id firewall-rules delete default-allow-https

echo "Fin"