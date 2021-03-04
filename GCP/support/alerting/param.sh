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

project_sa_alerts_notification_bem_name="alerts-notification-bem"
project_sa_alerts_notification_bem="$project_sa_alerts_notification_bem_name@ocb-big-data-sandbox.iam.gserviceaccount.com"
gce_sa_default="$project_number-compute@developer.gserviceaccount.com"
gcp_sa_monitoring_notification="service-$project_number@gcp-sa-monitoring-notification.iam.gserviceaccount.com"
storage_bucket_startup_config="bucket_startup_config"
pubsub_topic_name="alerts-tp"
pubsub_subscription_name="alerts-sub"
notification_channel_pubsub_name="alerts-pubsub-notification-channel"


policie_1_display_name="CPU Utilisation for lamp-1-VM"
policie_1_file_template="policies_CPU_utilization_template.yml"