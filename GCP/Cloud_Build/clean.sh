#!/bin/bash

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export PROJECT_NUMBER=$(gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)")

echo "Cloud Run : delete cloud-run-deploy"
gcloud run services delete cloud-run-deploy --platform="managed" --region="us-central1"

echo "Cloud Storage : delete buckets"
gsutil rm -r gs://"$PROJECT_ID"_cloudbuild/
gsutil rm -r gs://artifacts.$PROJECT_ID.appspot.com/

echo "IAM : Disable serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com"
echo "to roles/run.admin"
gcloud projects remove-iam-policy-binding data-proc-test-dla --member="serviceAccount:336543948613@cloudbuild.gserviceaccount.com" --role="roles/run.admin"
echo "roles/iam.serviceAccountUser"
gcloud projects remove-iam-policy-binding data-proc-test-dla --member="serviceAccount:336543948613@cloudbuild.gserviceaccount.com" --role="roles/iam.serviceAccountUser"

echo "API : Disable cloudbuild.googleapis.com and run.googleapis.com"
gcloud services disable cloudbuild.googleapis.com
gcloud services disable run.googleapis.com
