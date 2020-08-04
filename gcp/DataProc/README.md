# DataProc
## Source
https://cloud.google.com/dataproc/docs/quickstarts/quickstart-gcloud?hl=en_US#clean-up

```Shell
gcloud dataproc clusters list --region europe-west1
gcloud dataproc clusters describe cluster-6177 --region=europe-west1
gcloud dataproc clusters delete cluster-6177 --region=europe-west1
gsutil rm gs://dataproc-staging-europe-west1-336543948613-bh0vatyl/**
gsutil rm gs://dataproc-temp-europe-west1-336543948613-qcjksd6y/**
```

## Crération d'un cluster monoserveur
