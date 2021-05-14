#!/bin/bash
source param.sh

gcloud iam service-accounts create "alerts-notification-bem" --display-name="alerts-notification-bem" --project=$project_id
gcloud iam service-accounts list --project=$project_id

gcloud iam service-accounts list --filter="displayName: alerts-notification-bem" --format="value(email)" --project=$project_id
echo "nop"

gcloud iam service-accounts list --filter="displayName: alerts-notification-bem" --format="value(email)" --project=$project_id
echo "nupp"

alerts_notification_bem_email=$(gcloud iam service-accounts list --filter="displayName: alerts-notification-bem" --format="value(email)" --project=$project_id)
if [ "$alerts_notification_bem_email" != "" ] 
then
    gcloud pubsub subscriptions add-iam-policy-binding alerts-sub --role=roles/pubsub.subscriber --member=serviceAccount:$alerts_notification_bem_email
else
    echo "alerts_notification_bem_email est vide"
    echo "gcloud pubsub subscriptions add-iam-policy-binding alerts-sub --role=roles/pubsub.subscriber --member=serviceAccount:$alerts_notification_bem_email"
fi

gcloud iam service-accounts delete alerts-notification-bem@data-proc-test-dla.iam.gserviceaccount.com

echo "Fin"

