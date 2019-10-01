# Load Balancer sous AZURE

# Création d'une image de VM sous Centos avec Apache

## Création l'image
TODO création automatique

Dans /etc/rc.local ajout du démarrage auto d'apache et écriture des paramétres de la VM dans /var/www/html/index.html

```Shell
apachectl start
/var/project/initParam.sh
```
