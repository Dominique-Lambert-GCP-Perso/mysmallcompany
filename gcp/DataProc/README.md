# DataProc
## Source
https://cloud.google.com/dataproc/docs/quickstarts/quickstart-gcloud?hl=en_US#clean-up

```Shell
gcloud dataproc clusters delete cluster-6177 --region=europe-west1
gsutil rm gs://dataproc-staging-europe-west1-336543948613-bh0vatyl/**
gsutil rm -r gs://dataproc-temp-europe-west1-336543948613-qcjksd6y
gsutil rm gs://dataproc-temp-europe-west1-336543948613-qcjksd6y/**
gsutil rm -r gs://dataproc-staging-europe-west1-336543948613-bh0vatyl

```

## Crération d'un cluster Single Node
Cloud storage :
  # -b on : attention no ACL
```Shell
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla
  gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataproc-dla-temp
```Shell

Création du cluster
```Shell
gcloud dataproc clusters create cluster-dataproc-dla --enable-component-gateway --bucket cs-for-dataproc-dla --temp-bucket cs-for-dataproc-dla-temp --region europe-west1 --subnet default --zone europe-west1-b --single-node --master-machine-type n1-standard-1 --master-boot-disk-size 500 --image-version 1.3-debian10 --project data-proc-test-dla

Description du cluster
```Shell
gcloud dataproc clusters list --region europe-west1
gcloud dataproc clusters describe cluster-dataproc-dla --region=europe-west1

Lancer un job sur le cluster
gcloud dataproc jobs submit spark --cluster cluster-dataproc-dla --region europe-west1 --class org.apache.spark.examples.SparkPi --class org.apache.spark.examples.SparkPi --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000
