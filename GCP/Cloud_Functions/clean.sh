#!/bin/bash

PROJECT_ID="data-proc-test-dla"
REPOSITORY_ID="github_dominique-lambert-gcp-perso_mysmallcompany"
BRANCH_ID="master"
PATH_FUNCTION_DIR="GCP/Cloud_Functions/function_1/"

echo "Cloud function deploy"
gcloud functions delete function_1
