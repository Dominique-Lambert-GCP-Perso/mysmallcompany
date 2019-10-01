# Load Balancer sous AZURE

# Création d'une image de VM sous Centos avec Apache

## Création en automatique de l'image
dans /etc/rc.local ajout du démarrage auto d'apache et écriture des paramétres de la VM dans /var/www/html/index.html


apachectl start
/var/project/initParam.sh

