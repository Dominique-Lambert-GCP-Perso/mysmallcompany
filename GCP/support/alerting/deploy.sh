#!/bin/bash
source param.sh

echo "Cloud storage"
echo "Create bucket"
gsutil mb -l $project_region gs://$storage_bucket_startup_config

echo "Create VPN and Subnet"
gcloud compute networks create $project_vpc --project=$project_id --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create $project_vpc_subnet --project=$project_id --range=10.0.0.0/9 --network=$project_vpc --region=$project_region

echo "Création des régles de FireWall"
echo "Create firewall rules to allow tunneling"
gcloud compute firewall-rules create $fw_rule1_allow_ssh_from_iap \
    --source-ranges 35.235.240.0/20 \
    --target-tags "http-server,https-server" \
    --allow tcp \
    --network $project_vpc \
    --project=$project_id

echo "Création Cloud Router instances"
gcloud compute routers create $nat_router_europe_west1 \
    --network $project_vpc \
    --region $project_region \
    --project=$project_id

echo "Configure le Router pour Cloud NAT : permet l'accès internet pour les VM (sans IP privées)"
gcloud compute routers nats create $nat_config \
    --router-region $project_region \
    --router $nat_router_europe_west1 \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips \
    --project=$project_id

echo "Create a firewall rule named $fw_rule2_allow_lb_and_healthcheck"
gcloud compute firewall-rules create $fw_rule2_allow_lb_and_healthcheck \
    --source-ranges 130.211.0.0/22,35.191.0.0/16 \
    --target-tags "http-server,https-server" \
    --allow tcp:80 \
    --network $project_vpc \
    --project=$project_id

echo "Création de la machine $vm_1_lamp_1_vm"

echo "Copie du fichier de startup dans le bucket"
gsutil cp startup.sh  gs://$storage_bucket_startup_config/

gcloud compute instances create $vm_1_lamp_1_vm   \
            --project=$project_id           \
            --zone=$project_zone            \
            --machine-type=e2-micro         \
            --network-tier=PREMIUM          \
            --no-restart-on-failure         \
            --maintenance-policy=TERMINATE  \
            --preemptible                   \
            --service-account=$gce_sa_default \
            --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
            --tags=http-server,https-server     \
            --image=debian-10-buster-v20210217  \
            --image-project=debian-cloud        \
            --boot-disk-size=10GB               \
            --boot-disk-type=pd-standard        \
            --boot-disk-device-name=$vm_1_lamp_1_vm   \
            --no-shielded-secure-boot           \
            --shielded-vtpm                     \
            --shielded-integrity-monitoring     \
            --reservation-affinity=any          \
            --network-interface subnet=$project_vpc_subnet,no-address      \
            --metadata=startup-script-url=gs://$storage_bucket_startup_config/startup.sh

echo "Allocate an external IP address for load balancers"
echo "Create a static IP address named $lb_ipv4_cr for IPv4:"
gcloud compute addresses create $lb_ipv4_cr \
    --ip-version=IPV4       \
    --global                \
    --project=$project_id   

echo "Create a static IP address named $lb_ipv6_cr for IPv6:"
gcloud compute addresses create $lb_ipv6_cr \
    --ip-version=IPV6       \
    --global                \
    --project=$project_id   

echo "Create instance groups and add instances"
echo "Create the europe-resources-w instance group"
gcloud compute instance-groups unmanaged create $ig_europe_resources_w \
    --zone $project_zone   \
    --project=$project_id   

echo "Add lamp-1-vm instances in instance group"
gcloud compute instance-groups unmanaged add-instances $ig_europe_resources_w \
    --instances $vm_1_lamp_1_vm     \
    --zone $project_zone            \
    --project=$project_id   

echo "Create the load balancer"
echo "For the instance group define an HTTP service and map a port name to the relevant port"
gcloud compute instance-groups unmanaged set-named-ports $ig_europe_resources_w \
    --named-ports http:80           \
    --zone $project_zone            \
    --project=$project_id   

echo "Create a health check"
gcloud compute health-checks create http $http_basic_check \
    --port 80                       \
    --project=$project_id   

echo "Create a backend service:"
gcloud compute backend-services create $web_map_backend_service \
    --protocol HTTP                        \
    --health-checks $http_basic_check      \
    --global                               \
    --project=$project_id   

echo "Add your instance group as backend to the backend services"
gcloud compute backend-services add-backend $web_map_backend_service \
    --balancing-mode UTILIZATION            \
    --max-utilization 0.8                   \
    --capacity-scaler 1                     \
    --instance-group $ig_europe_resources_w \
    --instance-group-zone $project_zone     \
    --global                                \
    --project=$project_id   

echo "Set host and path rules"
echo "Create a default URL map that directs all incoming requests to all of your instances:"
gcloud compute url-maps create $web_map             \
    --default-service $web_map_backend_service      \
    --project=$project_id   

echo "Create a target HTTP proxy to route requests to the URL map:"
gcloud compute target-http-proxies create $http_lb_proxy    \
    --url-map $web_map                                     \
    --project=$project_id   

lb_ipv4_cr_value=$(gcloud compute addresses list --filter="name: $lb_ipv4_cr" --format="value(address)" --project=$project_id)
lb_ipv6_cr_value=$(gcloud compute addresses list --filter="name: $lb_ipv6_cr" --format="value(address)" --project=$project_id)

gcloud compute forwarding-rules create $http_cr_ipv4_rule \
    --address $lb_ipv4_cr_value                     \
    --global                                        \
    --target-http-proxy $http_lb_proxy              \
    --ports 80                                      \
    --project=$project_id   

gcloud compute forwarding-rules create $http_cr_ipv6_rule \
    --address $lb_ipv6_cr_value                     \
    --global                                        \
    --target-http-proxy $http_lb_proxy              \
    --ports 80                                      \
    --project=$project_id   

exit

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

