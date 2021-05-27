#!/bin/bash

for project in $(gcloud projects list --filter='lifecycleState:DELETE_REQUESTED' --format="value(projectId)")
do
    billingEnabled=$(gcloud alpha billing projects describe $project --format='value(billingEnabled)')
    if [ "$billingEnabled" = "False" ]
    then
        describe=$(gcloud projects describe $project --format='value(name,projectId,lifecycleState)')
        echo "billingEnabled=False, nothing to do : $describe"
    else
        echo "TO DO"
        echo "gcloud alpha billing projects unlink my-project"
    fi
done