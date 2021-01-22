# Alerting
## Source
Alerting : https://cloud.google.com/monitoring/alerts

Startup script : https://cloud.google.com/compute/docs/startupscript?_ga=2.149942910.-99729803.1610099568

## Création de la VM, déploiement des agent de logging, installation d'apache
deploy.sh :
Copie du fichier de startup vers le bucket
Création de la VM avec lancement du fichier startup.sh au lancement de la VM pour provisionning

deploy.sh
```Shell
  gcloud compute instances create lamp-1-vm 
      --zone=europe-west1-b 
      ...
      --metadata=startup-script-url=gs://test_bucket_dla/startup.sh  
```
startup.sh
Lancé au démarrage du la VM. Les log se se trouvent dans /var/log/deamon.log

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
