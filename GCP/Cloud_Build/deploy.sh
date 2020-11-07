#!/bin/bash

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")

echo "API : Enable cloudbuild.googleapis.com and run.googleapis.com"
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com

echo "IAM : Enable serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com"
echo "to roles/run.admin"
gcloud projects add-iam-policy-binding data-proc-test-dla --member="serviceAccount:336543948613@cloudbuild.gserviceaccount.com" --role="roles/run.admin"
echo "roles/iam.serviceAccountUser"
gcloud projects add-iam-policy-binding data-proc-test-dla --member="serviceAccount:336543948613@cloudbuild.gserviceaccount.com" --role="roles/iam.serviceAccountUser"



echo "Cloud Build & Run : build and deploy"
cd build-run
gcloud builds submit --config cloudbuild.yaml

cd ..
