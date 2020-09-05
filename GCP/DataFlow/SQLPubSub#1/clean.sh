#!/bin/bash

echo "cancel running job"
JOB_ID=$(gcloud dataflow jobs list --region europe-west1 --filter="name=dfsql-test-dla STATE=Running" --format="value(JOB_ID)");
if [ "$JOB_ID" != "" ]
then
    gcloud dataflow jobs cancel --region europe-west1 $JOB_ID
else
    echo no running job to delete
fi

echo "delete buckets"
gsutil -m rm -r gs://cs-for-dataflow-dla

echo "delete Pub/sub topic"
gcloud pubsub topics delete transactions

echo "delete Tables"
bq rm -f data-flow-test-dla:dataflow_sql_dataset.us_state_salesregions
bq rm -f data-flow-test-dla:dataflow_sql_dataset.dfsqltable_sales

echo "delete Dataset"
bq rm -f data-flow-test-dla:dataflow_sql_dataset

echo "Fin"
