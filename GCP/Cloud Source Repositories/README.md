# Cloud Source Repositories 

## Cloner un repos GCP en local
### Source
https://cloud.google.com/source-repositories/docs/cloning-repositories#clone_using_manually_generated_credentials

Avant de réaliser le git clone classique sur son poste il faut configurer git pour qu'il utilise le cookie d'authentification.

- Depuis le bouton "Clone", les diverses méthodes de clonnage sont proposées. 
- Utiliser le lien "? How to set up" pour la méthode "Manually generated credentials"
- Utiliser le lien "Generate and store your Git credentials"

![](https://github.com/Dominique-Lambert-GCP-Perso/mysmallcompany/blob/master/GCP/Cloud%20Source%20Repositories/Manually%20generate%20credential%20to%20git.PNG) 

- Aprés nouvelle demande d'authentification sur votre compte un lien vers "https://source.developers.google.com/new-password" s'affiche et propose les commandes de configuration de Git avec les crédentials associés à votre compte (jouer ces commandes sur votre poste).

![](https://github.com/Dominique-Lambert-GCP-Perso/mysmallcompany/blob/master/GCP/Cloud%20Source%20Repositories/Git%20Credentials.PNG)

## TO DO ou pas compris
- le clonnage en SSH ? a quoi sert la registration à quelle moment la clé public est utilisée, à quel moment la clé privé est demandée par git ?
