#!/bin/bash
project_id=$DEVSHELL_PROJECT_ID

if [ "$project_id" != "" ] 
then
    echo "Current project name : $project_id"
else
    echo "project name not set : quit"
    exit
fi

project_number=$(gcloud projects describe $project_id --format="value(project_number)")

use_case="monitoring-test"

project_vpc="vpc-$use_case"
project_vpc_subnet="subnet-$use_case"
project_region="europe-west1"
project_zone="europe-west1-b"

fw_rule1_allow_ssh_from_iap="allow-ssh-from-iap"
fw_rule2_allow_lb_and_healthcheck="allow-lb-and-healthcheck"

nat_router_europe_west1="nat-router-europe-west1"
nat_config="nat-config"

vm_1_lamp_1_vm="lamp-1-vm"

http_cr_ipv4_rule="http-cr-ipv4-rule"
http_cr_ipv6_rule="http-cr-ipv6-rule"
http_lb_proxy="http-lb-proxy"
web_map="web-map"
web_map_backend_service="web-map-backend-service"
http_basic_check="http-basic-check"
ig_europe_resources_w="ig-europe-resources-w"
lb_ipv4_cr="lb-ipv4-cr"
lb_ipv6_cr="lb-ipv6-cr"

project_sa_alerts_notification_bem_name="alerts-notification-bem"
project_sa_alerts_notification_bem="$project_sa_alerts_notification_bem_name@$project_id.iam.gserviceaccount.com"
gce_sa_default="$project_number-compute@developer.gserviceaccount.com"
gcp_sa_monitoring_notification="service-$project_number@gcp-sa-monitoring-notification.iam.gserviceaccount.com"
storage_bucket_startup_config="bucket_startup_config"
pubsub_topic_name="alerts-tp"
pubsub_subscription_name="alerts-sub"
notification_channel_pubsub_name="alerts-pubsub-notification-channel"

policie_1_display_name="CPU Utilisation for lamp-1-VM"
policie_1_file_template="policies_CPU_utilization_template.yml"