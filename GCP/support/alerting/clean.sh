#!/bin/bash
source param.sh
CLOUDSDK_CORE_DISABLE_PROMPTS=1
export CLOUDSDK_CORE_DISABLE_PROMPTS

#policie_name=$(gcloud alpha monitoring policies list --project=$project_id --filter="displayName: CPU Utilisation for lamp-1-VM" --format="value(name)")
#if [ "$policie_name" != "" ] 
#then
#    echo "Delete policie : name ($policie_name) "
#    gcloud alpha monitoring policies delete $policie_name
#fi

#pubsub_channel_name=$(gcloud alpha monitoring channels list --project=$project_id --filter='type="pubsub"' --format="value(name)")
#if [ "$pubsub_channel_name" != "" ] 
#then
#    echo "Delete channel de notification : name $pubsub_channel_name"
#    gcloud alpha monitoring channels delete $pubsub_channel_name
#fi

#echo "Delete service account : name (alerts-notification-bem)"
#gcloud iam service-accounts delete $project_sa_alerts_notification_bem

#echo "Delete de la subscription PubSub"
#gcloud pubsub subscriptions delete --project=$project_id $pubsub_subscription_name

#echo "Delete du topic PubSub : alerts-tp"
#gcloud pubsub topics delete --project=$project_id $pubsub_topic_name

echo "delete HTTP proxy"
gcloud compute forwarding-rules delete $http_cr_ipv4_rule --global --project=$project_id
gcloud compute forwarding-rules delete $http_cr_ipv6_rule --global --project=$project_id
gcloud compute target-http-proxies delete $http_lb_proxy --project=$project_id

echo "delete URL map"
gcloud compute url-maps delete $web_map --project=$project_id

echo "delete a backend service:"
gcloud compute backend-services delete $web_map_backend_service --project=$project_id --global

echo "delete a health check"
gcloud compute health-checks delete $http_basic_check --project=$project_id

echo "delete instance group"
gcloud compute instance-groups unmanaged delete $ig_europe_resources_w --zone $project_zone --project=$project_id   

echo "delete static IP address"
gcloud compute addresses delete $lb_ipv4_cr --project=$project_id --global
gcloud compute addresses delete $lb_ipv6_cr --project=$project_id --global

echo "delete VMs"
gcloud compute instances delete $vm_1_lamp_1_vm --zone=$project_zone --project=$project_id

echo "delete buckets"
gsutil rm -r gs://$storage_bucket_startup_config

echo "delete Cloud Router instances"
gcloud compute routers nats delete $nat_config --router $nat_router_europe_west1 --project=$project_id --router-region=$project_region
gcloud compute routers delete $nat_router_europe_west1 --project=$project_id --region=$project_region

echo "delete FireWall rules, subnet and VPC"
gcloud compute firewall-rules delete $fw_rule1_allow_ssh_from_iap --project=$project_id
gcloud compute firewall-rules delete $fw_rule2_allow_lb_and_healthcheck --project=$project_id
gcloud compute networks subnets delete $project_vpc_subnet --project=$project_id --region=$project_region
gcloud compute networks delete $project_vpc --project=$project_id

echo "Fin"