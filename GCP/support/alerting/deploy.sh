#!/bin/bash
source param.sh

echo "Cloud storage : Copie du fichier de startup dans le bucket"
gsutil cp startup.sh  gs://test_bucket_dla/

echo "Création des réseaux et sous-réseaux"

echo "Création des régles de FireWall"
gcloud compute --project=$project_id firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute --project=$project_id firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

echo "Création de la machine lamp-1-vm"
gcloud compute instances create lamp-1-vm --project=$project_id --zone=europe-west1-b --machine-type=e2-micro --subnet=default --network-tier=PREMIUM --no-restart-on-failure --maintenance-policy=TERMINATE --preemptible --service-account=336543948613-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-10-buster-v20210122 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=lamp-1-vm --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --metadata=startup-script-url=gs://test_bucket_dla/startup.sh  

echo "Création du topic PUB/SUB : alerts-tp"
gcloud pubsub topics create --project=$project_id alerts-tp

echo "Création d'une subscription"
gcloud pubsub subscriptions create $pubsub_subscription_name --project=$project_id --topic alerts-tp --topic-project $project_id

echo "Création du channel de notification"
gcloud alpha monitoring channels create --display-name="alerts-sub-channel" --type=pubsub --channel-labels=topic=projects/data-proc-test-dla/topics/alerts-tp --project=$project_id

echo "Ajout du droit de publier sur le topic pour le compte de service"
project_number=$(gcloud projects describe data-proc-test-dla --format="value(project_number)")
gcloud pubsub topics add-iam-policy-binding projects/data-proc-test-dla/topics/alerts-tp --role=roles/pubsub.publisher --member=serviceAccount:service-$project_number@gcp-sa-monitoring-notification.iam.gserviceaccount.com

echo "Création du compte de service de consomation des messages du topic name : alerts-notification-bem"
gcloud iam service-accounts create "alerts-notification-bem" --display-name="alerts-notification-bem" --project=$project_id
sleep 5 # burk !

alerts_notification_bem_email=$(gcloud iam service-accounts list --filter="displayName: alerts-notification-bem" --format="value(email)" --project=$project_id)
if [ "$alerts_notification_bem_email" != "" ] 
then
    gcloud pubsub subscriptions add-iam-policy-binding alerts-sub --role=roles/pubsub.subscriber --member=serviceAccount:$alerts_notification_bem_email
else
    echo "alerts_notification_bem_email est vide"
    echo "gcloud pubsub subscriptions add-iam-policy-binding alerts-sub --role=roles/pubsub.subscriber --member=serviceAccount:$alerts_notification_bem_email"
fi

echo "Ajout de la policie : CPU Utilisation for lamp-1-VM"
gcloud alpha monitoring policies create --policy-from-file=policies_CPU_utilization_template.yml --project=$project_id
policie_name=$(gcloud alpha monitoring policies list --filter="displayName: CPU Utilisation for lamp-1-VM" --format="value(name)" --project=$project_id)
channel_list=$(gcloud alpha monitoring channels list --format='value[terminator=","](name)' --project=$project_id)
gcloud alpha monitoring policies update $policie_name --set-notification-channels="$channel_list" --project=$project_id

echo "Fin"

