# Cloud Source Repositories 

## Cloner un repos GCP en local
### Source
https://cloud.google.com/source-repositories/docs/cloning-repositories#clone_using_manually_generated_credentials

Avant de réaliser le git clone classique sur son poste il faut configurer git pour qu'il utilise le cookie d'authentification.

- Depuis le bouton "Clone", les diverses méthodes de clonnage sont proposées. 
- Utiliser le lien "? How to set up" pour la méthode "Manually generated credentials"
- Utiliser le lien "Generate and store your Git credentials"

![](https://github.com/Dominique-Lambert-GCP-Perso/mysmallcompany/blob/master/GCP/Cloud%20Source%20Repositories/Manually%20generate%20credential%20to%20git.PNG) 

- Aprés une nouvelle demande d'authentification sur votre compte un lien vers "https://source.developers.google.com/new-password" s'affiche et propose les commandes de configuration de Git avec les crédentials associés à votre compte (jouer ces commandes sur votre poste).

![](https://github.com/Dominique-Lambert-GCP-Perso/mysmallcompany/blob/master/GCP/Cloud%20Source%20Repositories/Git%20Credentials.PNG)

## Cloner un repos GCP mirroir de GitHub
Ne pose pas de diffilculté à mettre en place. Mais finalement n'offre que peu d'avantage puisque qu'il n'est pas possiblede commiter sur le repo mirroir sous GCP.
Le message lors du git push (depuis le repos GCP) n'est pas trés explicite.

```Shell
dlambert_family@cloudshell:~/github_dominique-lambert-gcp-perso_mysmallcompany (data-proc-test-dla)$ git push
remote: PERMISSION_DENIED: The caller does not have permission
remote: [type.googleapis.com/google.rpc.LocalizedMessage]
remote: locale: "en-US"
remote: message: "The remote repository is a read-only mirror of https://github.com/Dominique-Lambert-GCP-Perso/mysmallcompany.\nTo update, please push there."
remote:
remote: [type.googleapis.com/google.rpc.RequestInfo]
remote: request_id: "d8e94ba5845c46ffb207c27388ab7774"
fatal: unable to access 'https://source.developers.google.com/p/data-proc-test-dla/r/github_dominique-lambert-gcp-perso_mysmallcompany/': The requested URL returned error: 403
```

## TO DO ou pas compris
- le clonnage en SSH ? (ne fonctionne qui si le poste client est accédé en SSH, ou sous linux)

```Shell
Utilisateur@DESKTOP-4G169MH MINGW32 ~/Documents
$ git clone ssh://dlambert.family@gmail.com@source.developers.google.com:2022/p/data-proc-test-dla/r/test_repo
Cloning into 'test_repo'...
dlambert.family@gmail.com@source.developers.google.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```
