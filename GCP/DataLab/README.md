# DataLab

## Source
https://github.com/googledatalab/datalab/tree/master/containers/datalab

2 commandes
- datalab create test
- datalab connect test

## bjectif
- analyser les commandes GCP et les principes de création et de connection à l'instance datalab
(projet datalab dans eclipse-workspace)

## datalab create
Préparation

Vérification de l'existance du réseau (par défaut nommé datalab-network)
```Shell
gcloud compute --project test-datalab-246315 --verbosity=error --quiet networks describe --format value(name) datalab-network
```

Vérification de l'existance des régles de firewall
```Shell
gcloud compute --project test-datalab-246315 --verbosity=error firewall-rules list --filter network~.^*datalab-network$ --format value(name)
```

Vérification de l'existance du disque persistant (test-pd)
```Shell
gcloud compute --project test-datalab-246315 --verbosity=error --quiet disks describe test-pd --format value(name) --zone europe-west1-b
```

Run
```Shell
gcloud compute --project test-datalab-246315 --verbosity=error 
  instances create 
          --zone europe-west1-b 
          --format=none 
          --boot-disk-size=20GB 
          --network datalab-network 
          --image-family cos-stable 
          --image-project cos-cloud 
          --machine-type n1-standard-1 
          --metadata-from-file startup-script=startup-script.py,user-data=user-data.cloud-config.txt,for-user=for-user.txt,enable-oslogin=enable-oslogin.txt,created-with-sdk-version=created-with-sdk-version.txt,created-with-datalab-version=created-with-datalab-version.txt 
          --tags datalab 
          --disk "auto-delete=no,boot=no,device-name=datalab-pd,mode=rw,name=test-pd" 
          --service-account default 
          --scopes cloud-platform test
```
## Datalab connect

```Shell
gcloud.cmd compute --project test-datalab-246315 --verbosity=error ssh --zone europe-west1-b --ssh-flag=-4 --ssh-flag=-N --ssh-flag=-L --ssh-flag=localhost:8081:localhost:8080 datalab@test
```

