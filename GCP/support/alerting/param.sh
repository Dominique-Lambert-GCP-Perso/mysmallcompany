#!/bin/bash
project_id=data-proc-test-dla
project_number=$(gcloud projects describe data-proc-test-dla --format="value(project_number)")
pubsub_topic_name=alerts-tp
pubsub_subscription_name=alerts-sub