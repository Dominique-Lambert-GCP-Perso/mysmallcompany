#!/bin/bash

echo "Enable API"
gcloud services enable dataflow.googleapis.com pubsub.googleapis.com 
gcloud services list

echo "Cloud storage : Création des bucket"
gsutil mb -b on -c Standard -l EUROPE-WEST1 gs://cs-for-dataflow-dla

echo "Fin"