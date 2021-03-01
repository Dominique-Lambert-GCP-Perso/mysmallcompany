echo "coucouc" > /tmp/startup.log

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

# Install stress tool
sudo apt-get install stress