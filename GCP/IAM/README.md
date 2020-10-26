# IAM
## Public Idententity
  username : ext_dlambert_family_gmail_com
  email : dlambert.family@gmail.com
  clé public : ext.dlambert.family.pub
  organisation : externe

  username : leslie_johnson_mysmallcompany_tv
  email : leslie.johnson@mysmallcompany.tv
  clé public : leslie.johnson.pub
  organisation : mysmallcompany.tv


## Set OS Login
source : https://cloud.google.com/compute/docs/instances/managing-instance-access?hl=fr#enable_oslogin

Pour se connecter au système d'exploitation (OS Login) le user doit avoir le rôle roles/compute.osAdminLogin (ou compute.osLogin)

Le rôle primitife owner contient déjà le rôle compute.osAdminLogin
```Shell
  gcloud projects get-iam-policy data-flow-test-dla --format json > permissions.json
  # Set permission in perssions.json
  gcloud projects set-iam-policy data-flow-test-dla permissions.json
```

Pour se connecter avec une clé SSH il faut ajouter la clé publique SSH au profile utilisateur
```Shell
gcloud compute os-login ssh-keys add --key-file leslie.johnson.pub
```

Pour afficher le profile utilisateur.

Le nom d'utilisateur est username (ici leslie_johnson_mysmallcompany_tv)

```Shell
gcloud compute os-login describe-profile
name: '108346849022812853176'
posixAccounts:
- gid: '624197345'
  homeDirectory: /home/leslie_johnson_mysmallcompany_tv
  operatingSystemType: LINUX
  primary: true
  uid: '624197345'
  username: leslie_johnson_mysmallcompany_tv
sshPublicKeys:
  4350b39aaf52ec1e8d13a09f78723a70cc4f233ecbc4bcd4049cb699aa17843f:
    fingerprint: 4350b39aaf52ec1e8d13a09f78723a70cc4f233ecbc4bcd4049cb699aa17843f
    key: ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAs8Fwjq6nmaJod0kApQ9ZbQH2x3ktbGp/TeAGp6imxdxAj4Yv5cRHJFdctrGNzvTmeXwb0e4UYuuHweA5yjQb5hriUVfPYeO0m8EoQCFsVpETeShIOiJ6aKnTo6+EBnlE3jKLMilG4lGo7pynsISZjwzI0bD9lrVmDzQR1deuIs+2r9lcWGbmycKJfnH907x6EA2F79CkJD0iGQ+T8vuzqQU3wvpHhhDFG4LT66/CFKk6AS7ji1Zt9losEWD+qRzxV2L0qMbm4WFodk7904rJYKvY3SxsM/sL45sd+J0pIzSg2PH3CfEq2z80ZhSkiOoJF6x8mN5xsXIaD4A0MldMlw==
      leslie.johnson
    name: users/leslie.johnson@mysmallcompany.tv/sshPublicKeys/4350b39aaf52ec1e8d13a09f78723a70cc4f233ecbc4bcd4049cb699aa17843f
```

TODO : déterminer qui à le droit de modifier un profile utilisteur sachant que la clé Pulique SSH ne peut être gérée via Cloud Identity (Mais peut l'être avec GSuite)
TODO : posixAccounts semble "immutable", le compte dlambert.efamily.gmail.com par exemple semble être 'vérolé' avec des valeurs de 'account' settées avec des id de projets anciens.

Pour activer OS Login sur la VM la meta donnée enable-oslogin doit être initialisée à TRUE (la meta donnée peut-être settée au niveau du projet)
```Shell
  gcloud beta compute --project=${project} instances create reverse-shell-server \
    --zone=europe-west1-b \
    --machine-type=e2-micro \
    --subnet=default \
    --no-restart-on-failure \
    --network-tier=PREMIUM \
    --maintenance-policy=TERMINATE \
    --preemptible \
    --service-account=220526071536-compute@developer.gserviceaccount.com  \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --tags=http-server \
    --image=centos-7-v20200910 \
    --image-project=centos-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=reverse-shell-server \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any \
    --metadata enable-oslogin=TRUE
```

TODO : lorsque qu'un utilisateur se connecte avec OS Login il semble andoser le compte de service setté au moment de la création de la VM (voir peut-être roles/iam.serviceAccountUser)

## Utilisation d'un compte de service
# Source
https://cloud.google.com/iam/docs/service-accounts?hl=fr
https://cloud.google.com/iam/docs/impersonating-service-accounts?hl=fr

# exemple de compte de service pour terraform

Récupérer la list des comptes de service
```Shell
gcloud iam service-accounts list
DISPLAY NAME                            EMAIL                                                 DISABLED
terraform                               terraform@data-proc-test-dla.iam.gserviceaccount.com  False
Compute Engine default service account  336543948613-compute@developer.gserviceaccount.com    False
```

Récupérer les permissions associées au compte de service terraform
```Shell
gcloud iam service-accounts get-iam-policy terraform@data-proc-test-dla.iam.gserviceaccount.com --format=json > policy.json
```

```Json
{
  "etag": "ACAB"
}
```
