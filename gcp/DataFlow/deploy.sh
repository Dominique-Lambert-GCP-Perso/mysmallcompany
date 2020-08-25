#!/bin/bash

echo "Enable API"
gcloud services enable dataflow.googleapis.com pubsub.googleapis.com 
gcloud services list
echo "Fin"
