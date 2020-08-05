# DataProc
## Source
https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network?hl=en_US&authuser=0#custom

## Crération d'un cluster Single Node
Cloud storage : 
-b on : attention no ACL
```Shell
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla-temp
```

Création des réseaux et sous-réseaux

```Shell
gcloud compute networks create vpc-dataproc --project=data-proc-test-dla --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create subnet-dataproc --project=data-proc-test-dla --range=10.0.0.0/9 --network=vpc-dataproc --region=europe-west1 --enable-private-ip-google-access
```

Création régle de FireWall
```Shell
gcloud compute --project=data-proc-test-dla firewall-rules create vpc-dataproc-allow-internal --direction=INGRESS --priority=1000 --network=vpc-dataproc --action=ALLOW --rules=udp:0-65535,tcp:0-65535,icmp --source-ranges=10.0.0.0/9
```


Création du cluster
```Shell
gcloud dataproc clusters create cluster-dataproc-dla --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet default --no-address --zone europe-west1-b --single-node --master-machine-type n1-standard-1 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla
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

Suppressions
```Shell
gcloud dataproc clusters delete cluster-dataproc-dla --region europe-west1
gsutil rm -r gs://cs-for-dataproc-dla
gsutil rm -r gs://cs-for-dataproc-dla-temp
```
