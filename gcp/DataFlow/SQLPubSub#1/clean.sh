#!/bin/bash

echo "delete buckets"
gsutil -m rm -r gs://cs-for-dataflow-dla

echo "delete Pub/sub topic"
gcloud pubsub topics delete transactions

echo "delete Dataset"
bq rm -f data-flow-test-dla:dataflow_sql_dataset

echo "Fin"
