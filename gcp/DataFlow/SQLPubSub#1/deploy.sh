#!/bin/bash

echo "Enable API"
gcloud services enable dataflow.googleapis.com pubsub.googleapis.com datacatalog.googleapis.com bigqueryconnection.googleapis.com
gcloud services list

echo "Cloud storage : Création des bucket"
gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataflow-dla

echo "Create Pub/Sub topic"
gcloud pubsub topics create transactions

echo "BigQuery : create dataset" 
bq --location EU mk --dataset --description "dataset pour dataflow SQLPubSub#1" data-flow-test-dla:dataflow_sql_dataset

echo "BigQuery : create table" 
bq --location EU load --source_format=CSV --autodetect --skip_leading_rows=1 data-flow-test-dla:dataflow_sql_dataset.us_state_salesregions us_state_salesregions.csv

echo "Data-Catalog : attach schema to PubSub Topic" 
gcloud data-catalog entries update --lookup-entry='pubsub.topic.`data-flow-test-dla`.transactions' --schema-from-file=pubsub-schema.json

echo "DataFlow : create Dataflow job" 
gcloud dataflow sql query 'SELECT tr.*, sr.sales_region
FROM pubsub.topic.`data-flow-test-dla`.transactions as tr
  INNER JOIN bigquery.table.`data-flow-test-dla`.dataflow_sql_dataset.us_state_salesregions AS sr
  ON tr.state = sr.state_code' --job-name dfsql-test-dla --region europe-west1 --bigquery-write-disposition write-empty --bigquery-project data-flow-test-dla --bigquery-dataset dataflow_sql_dataset --bigquery-table dfsqltable_sales

echo "Fin"
