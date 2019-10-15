# Docker machine

## Sources get started
https://docs.microsoft.com/fr-fr/azure/virtual-machines/linux/docker-machine
https://github.com/Azure-Samples/acr-build-helloworld-node

Cloud Shell sous Azure ne permet pas de builder une image docker (???)
Avec docker machine il est possible de créer un host docker


## Récupération du subscription-id
```Shell
sub=$(az account show --query "id" -o tsv)
```

## Création du host 
```Shell

docker-machine create   -d azure 
						--azure-subscription-id $sub 
						--azure-ssh-user dla 
						--azure-open-port 80 
						--azure-size "Standard_DS2_v2" mydocker

```

## Connexion au host

```Shell
docker-machine ssh mydocker
```

## Build d'un conteneur exemple (simple node.js)
```Shell
git clone https://github.com/Azure-Samples/acr-build-helloworld-node
cd acr-build-helloworld-node
docker build -t helloacrbuild:v1 .
docker run -d -p 8091:80 helloacrbuild:v1
Navigate to http://localhost:8091 to view the running application
```

## Accès via l'IP public
"docker-machine create" a créer  :

- docker-machine : groupe de resources
- docker-machine : availibility set
- my docker : un host
- mydocker_ip
- mydocker_firewall
	
Le service HTTP délivré par le conteneur est accessible via l'ip public sur le port 8091 a condition d'ajouter la régle "inbound decurity rules" pour autorisé à sortir en 8091

Question : comment docker machine gère les cles publique pour autoriser la connexion ?
