#!/bin/bash

echo "Cloud storage : Copie du fichier de startup dans le bucket"
#gsutil cp startup.sh  gs://test_bucket_dla/

echo "Création des réseaux et sous-réseaux"

echo "Création des régles de FireWall"
#gcloud compute --project=data-proc-test-dla firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
#gcloud compute --project=data-proc-test-dla firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

echo "Création de la machine lamp-1-vm"
#gcloud compute instances create lamp-1-vm --zone=europe-west1-b --machine-type=e2-micro --subnet=default --network-tier=PREMIUM --no-restart-on-failure --maintenance-policy=TERMINATE --preemptible --service-account=336543948613-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-10-buster-v20210122 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=lamp-1-vm --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --metadata=startup-script-url=gs://test_bucket_dla/startup.sh  

echo "Création du topic PUB/SUB : alerts-tp"
#gcloud pubsub topics create alerts-tp

echo "Création d'une subscription"
#gcloud pubsub subscriptions create alerts-sub --topic alerts-tp --topic-project data-proc-test-dla

echo "Création du channel de notification"
#gcloud alpha monitoring channels create --display-name="alerts-sub-channel" --type=pubsub --channel-labels=topic=projects/data-proc-test-dla/topics/alerts-tp

echo "Ajout du droit de publier sur le topic piur le compte de service"
#project_id=$(gcloud projects describe data-proc-test-dla --format="value(project_number)")
#gcloud pubsub topics add-iam-policy-binding projects/data-proc-test-dla/topics/alerts-tp --role=roles/pubsub.publisher --member=serviceAccount:service-$project_id@gcp-sa-monitoring-notification.iam.gserviceaccount.com

echo "Ajout de la policie : CPU Utilisation for lamp-1-VM"
gcloud alpha monitoring policies create --policy-from-file=policies_CPU_utilization_template.yml
policie_name=$(gcloud alpha monitoring policies list --filter="displayName: CPU Utilisation for lamp-1-VM" --format="value(name)")
echo $policie_name
channel_list=$(gcloud alpha monitoring channels list --format='value[terminator=","](name)')
echo $channel_list
gcloud alpha monitoring policies update $policie_name --set-notification-channels="$channel_list"

echo "Fin"

