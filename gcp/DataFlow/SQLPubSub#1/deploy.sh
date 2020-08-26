#!/bin/bash

echo "Enable API"
gcloud services enable dataflow.googleapis.com pubsub.googleapis.com datacatalog.googleapis.com
gcloud services list

echo "Cloud storage : Création des bucket"
gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataflow-dla

echo "Create Pub/Sub topic"
gcloud pubsub topics create transactions

echo "BigQuery : create dataset" 
bq --location EU mk --dataset --description "dataset pour dataflow SQLPubSub#1" data-flow-test-dla:dataflow_sql_dataset

echo "Fin"