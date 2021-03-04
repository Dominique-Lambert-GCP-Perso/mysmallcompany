#!/bin/bash
source param.sh

echo "Cloud storage : Copie du fichier de startup dans le bucket"
echo "Create bucket"
gsutil mb -l europe-west1 gs://$storage_bucket_startup_config

echo "Copie du fichier de startup dans le bucket"
gsutil cp startup.sh  gs://$storage_bucket_startup_config/

echo "Création des régles de FireWall"
gcloud compute --project=$project_id firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute --project=$project_id firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

echo "Création de la machine lamp-1-vm"
gcloud compute instances create lamp-1-vm   \
            --project=$project_id           \
            --zone=europe-west1-b           \
            --machine-type=e2-micro         \
            --subnet=default                \
            --network-tier=PREMIUM          \
            --no-restart-on-failure         \
            --maintenance-policy=TERMINATE  \
            --preemptible                   \
            --service-account=$gce_sa_default \
            --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
            --tags=http-server,https-server     \
            --image=debian-10-buster-v20210122  \
            --image-project=debian-cloud        \
            --boot-disk-size=10GB               \
            --boot-disk-type=pd-standard        \
            --boot-disk-device-name=lamp-1-vm   \
            --no-shielded-secure-boot           \
            --shielded-vtpm                     \
            --shielded-integrity-monitoring     \
            --reservation-affinity=any          \
            --metadata=startup-script-url=gs://$storage_bucket_startup_config/startup.sh

echo "Création du topic PUB/SUB : ($pubsub_topic_name)"
gcloud pubsub topics create --project=$project_id $pubsub_topic_name

echo "Création d'une subscription : ($pubsub_subscription_name)"
gcloud pubsub subscriptions create $pubsub_subscription_name --project=$project_id --topic $pubsub_topic_name --topic-project $project_id

echo "Création du channel de notification : ($notification_channel_pubsub_name)"
alerts_tp_fullname=$(gcloud pubsub topics describe $pubsub_topic_name --format="value(name)")
if [ "$alerts_tp_fullname" != "" ] 
then
    gcloud alpha monitoring channels create                             \
            --display-name="$notification_channel_pubsub_name"          \
            --type=pubsub --channel-labels=topic=$alerts_tp_fullname    \
            --project=$project_id
else
    echo "ERROR alerts-tp-fullname est vide"   
fi

echo "Ajout du droit de publier sur le topic ($pubsub_topic_name) pour le compte de service gcp monitoring notification : ($gcp_sa_monitoring_notification)"
gcloud pubsub topics add-iam-policy-binding                         \
            $pubsub_topic_name                                     \
            --role=roles/pubsub.publisher                           \
            --member=serviceAccount:$gcp_sa_monitoring_notification \

project_sa_alerts_notification_bem_display_name="alerts-notification-bem"
project_sa_alerts_notification_bem="$project_sa_alerts_notification_bem_display_name@ocb-big-data-sandbox.iam.gserviceaccount.com"


echo "Création du compte de service de consomation des messages du topic ($pubsub_topic_name) : ($project_sa_alerts_notification_bem)"
gcloud iam service-accounts create $project_sa_alerts_notification_bem_name --display-name="$project_sa_alerts_notification_bem_name" --project=$project_id

echo "Ajout du droit de soucrire sur la subscription ($pubsub_subscription_name) pour le compte de service projet : ($project_sa_alerts_notification_bem)"
gcloud pubsub subscriptions add-iam-policy-binding                  \
            $pubsub_subscription_name                               \
            --role=roles/pubsub.subscriber                          \
            --member=serviceAccount:$project_sa_alerts_notification_bem

notification_channels=$(gcloud alpha monitoring channels list --format='value[terminator=","](name)' --project=$project_id)
echo "Liste des channels de comunication des notifications de monitoring ($notification_channels)"

echo "Ajout de la policie : CPU Utilisation for lamp-1-VM"
gcloud alpha monitoring policies create                                     \
        --policy-from-file=$policie_1_file_template                         \
        --display-name="$policie_1_display_name"                            \
        --notification-channels="$notification_channels"                    \
        --project=$project_id

echo "Fin"

