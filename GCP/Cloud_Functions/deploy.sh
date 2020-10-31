#!/bin/bash

PROJECT_ID="data-proc-test-dla"
REPOSITORY_ID="github_dominique-lambert-gcp-perso_mysmallcompany"
BRANCH_ID="master"
PATH_FUNCTION_DIR="GCP/Cloud_Functions/function_1/"

echo "Cloud function deploy"
gcloud functions deploy function_1 \
		--runtime python37 \
		--allow-unauthenticated \
		--source "https://source.developers.google.com/projects/$PROJECT_ID/repos/$REPOSITORY_ID/moveable-aliases/$BRANCH_ID/paths/$PATH_FUNCTION_DIR" \
		--memory "128MB" --trigger-http \
		--entry-point "greetings_http"
