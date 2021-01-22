# Alerting
## Source
Alerting : https://cloud.google.com/monitoring/alerts

Startup script : https://cloud.google.com/compute/docs/startupscript?_ga=2.149942910.-99729803.1610099568

## Création de la VM, déploiement des agent de logging, installation d'apache
deploy.sh :
* Copie du fichier de startup vers le bucket
* Création de la VM avec lancement du fichier startup.sh au lancement de la VM pour provisionning
* sortie : voir http::/IP_PUBLIC -> page apache
```Shell
  gcloud compute instances create lamp-1-vm 
      --zone=europe-west1-b 
      ...
      --metadata=startup-script-url=gs://test_bucket_dla/startup.sh  
```
startup.sh :
* Lancé au démarrage du la VM. Les log se se trouvent dans /var/log/deamon.log

```Shell
# Update the package lists on your instance.
sudo apt-get update

# Set up the Apache2 HTTP Server
sudo apt-get install apache2 php7.0 -y

# Install and start the Cloud Monitoring agent:
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
sudo apt-get update
sudo apt-get install stackdriver-agent -y

# Install, configure, and start the Cloud Logging agent:
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh
sudo apt-get update

sudo apt-get install google-fluentd
sudo apt-get install google-fluentd-catch-all-config-structured
sudo service google-fluentd start

```

## Configuration du Uptime checks via la console
test de l'arret de service apache => levée d'arte sur l'application mobile

## Configuration via gcloud (en version alpha)

```Shell
gcloud alpha monitoring policies list
```

```json
combiner: OR
conditions:
- conditionThreshold:
    aggregations:
    - alignmentPeriod: 1200s
      crossSeriesReducer: REDUCE_COUNT_FALSE
      groupByFields:
      - resource.label.*
      perSeriesAligner: ALIGN_NEXT_OLDER
    comparison: COMPARISON_GT
    duration: 60s
    filter: metric.type="monitoring.googleapis.com/uptime_check/check_passed" AND
      metric.label.check_id="my-uptime-check" AND resource.type="gce_instance"
    thresholdValue: 1.0
    trigger:
      count: 1
  displayName: Failure of uptime check_id my-uptime-check
  name: projects/data-proc-test-dla/alertPolicies/7394571819462344725/conditions/7394571819462345344
creationRecord:
  mutateTime: '2021-01-22T15:33:19.111235366Z'
  mutatedBy: dlambert.family@gmail.com
displayName: My Uptime Check uptime failure
enabled: true
mutationRecord:
  mutateTime: '2021-01-22T15:33:19.111235366Z'
  mutatedBy: dlambert.family@gmail.com
name: projects/data-proc-test-dla/alertPolicies/7394571819462344725
notificationChannels:
- projects/data-proc-test-dla/notificationChannels/5504648379332005065
```





