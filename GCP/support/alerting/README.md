# DataProc
## Source
https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network?hl=en_US&authuser=0#custom

## Création d'un cluster Single Node
Cloud storage : Création des bucket
-b on : attention no ACL
```Shell
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla-temp
```

Création des réseaux et sous-réseaux
avec --enable-private-ip-google-access
```Shell
gcloud compute networks create vpc-dataproc --project=data-proc-test-dla --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create subnet-dataproc --project=data-proc-test-dla --range=10.0.0.0/9 --network=vpc-dataproc --region=europe-west1 --enable-private-ip-google-access
```

Création des régles de FireWall
Uniquement des autorisations de flux internes aux VPC et Subnet
```Shell
gcloud compute --project=data-proc-test-dla firewall-rules create vpc-dataproc-allow-internal --direction=INGRESS --priority=1000 --network=vpc-dataproc --action=ALLOW --rules=udp:0-65535,tcp:0-65535,icmp --source-ranges=10.0.0.0/9
gcloud compute --project=data-proc-test-dla firewall-rules create vpc-dataproc-allow-ssh --direction=INGRESS --priority=1000 --network=vpc-dataproc --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0
```

Création du cluster
--no-address : pas d'IP publics
```Shell
gcloud dataproc clusters create cluster-dataproc-dla --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet subnet-dataproc --no-address --zone europe-west1-b --single-node --master-machine-type n1-standard-1 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla
```

Description du cluster
```Shell
gcloud dataproc clusters list --region europe-west1
gcloud dataproc clusters describe cluster-dataproc-dla --region=europe-west1
```

Lancer un job sur le cluster
```Shell
gcloud dataproc jobs submit spark --cluster cluster-dataproc-dla --region europe-west1 --class org.apache.spark.examples.SparkPi --class org.apache.spark.examples.SparkPi --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000
```

Accès au cluster par tunnel SSH
```Shell
gcloud beta compute ssh --zone "europe-west1-b" "cluster-dataproc-dla-m" --tunnel-through-iap --project "data-proc-test-dla"
```

Suppressions
```Shell

gcloud dataproc clusters delete cluster-dataproc-dla --region europe-west1
gsutil rm -r gs://cs-for-dataproc-dla
gsutil rm -r gs://cs-for-dataproc-dla-temp
gcloud compute --project=data-proc-test-dla firewall-rules delete vpc-dataproc-allow-internal
gcloud compute --project=data-proc-test-dla firewall-rules delete vpc-dataproc-allow-ssh
gcloud compute networks subnets delete subnet-dataproc --project=data-proc-test-dla
gcloud compute networks delete vpc-dataproc --project=data-proc-test-dla

```

## Source
https://cloud.google.com/dataproc/docs/tutorials/spark-scala?hl=fr

## Écrire et exécuter des tâches Spark Scala sur Cloud Dataproc
Remarque : spark-shell ne s'est pas lancé lorsque le cluster mono-server 
  - comprennait "--optional-components=ANACONDA,DRUID,ZOOKEEPER,HBASE,HIVE_WEBHCAT,JUPYTER"
  - étaiat de type n1-standard-1 => passé en n1-standard-2

TODO : les écritures gs:// semblent fonctionner depuis Spark => voir s'il existe des limitations connues

