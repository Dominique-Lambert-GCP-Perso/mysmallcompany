# DataFlow 

## Joining streaming data with Dataflow SQL
https://cloud.google.com/dataflow/docs/samples/join-streaming-data-with-sql?authuser=0&hl=en_US

deploy.sh
  - Enable APIS
  - Create bucket
  - Create bigquery dataset
  - Create table
```Shell
echo "BigQuery : create table" 
  bq --location EU load --source_format=CSV --autodetect --skip_leading_rows=1 data-flow-test-dla:dataflow_sql_dataset.us_state_salesregions us_state_salesregions.csv
```
   - La HandsOn ne donne pas la commande de chargement (/création) de la table à partir du fichier csv

  - Attach schema to pub/sub topic
  
```Shell
  echo "Data-Catalog : attach schema to PubSub Topic" 
gcloud data-catalog entries update --lookup-entry='pubsub.topic.`data-flow-test-dla`.transactions' --schema-from-file=pubsub-schema.json
```
   - Le schéma n'est pas attaché firectement au topic mais renseingé dans Data Catalog (référence les sources de données leurs méta données techniques et commerciales)
    
   - La ressources Pub/Sub est recherchée par un lookup-entry (notion à clarifiée)
    
   - Le HandsOn donne le schéma du topic Pub/Sub (qui va être utiliser par le job pour matché entre les données json déposée sur le topic et la lecture en mode SQL) mais avec une erreur (remplacer l'attribut 'name' par 'column' => qui s'appel ensuite filed dans l'UI).
      - pubsub-schema.json et pubsub-schema.yml (les 2 fonctionnent)
  
  - DataFlow : create Dataflow job
  ```Shell
echo "DataFlow : create Dataflow job" 
gcloud dataflow sql query 'SELECT tr.*, sr.sales_region
FROM pubsub.topic.`data-flow-test-dla`.transactions as tr
  INNER JOIN bigquery.table.`data-flow-test-dla`.dataflow_sql_dataset.us_state_salesregions AS sr
  ON tr.state = sr.state_code' --job-name dfsql-test-dla --region europe-west1 --bigquery-write-disposition write-empty --bigquery-project data-flow-test-dla --bigquery-dataset dataflow_sql_dataset --bigquery-table dfsqltable_sales
```
Describe du job :
```Shell
gcloud dataflow jobs describe --region europe-west1 2020-08-27_09_07_26-10918414365182703414 --format="json"
```
```json
{
  "createTime": "2020-08-27T16:07:27.037488Z",
  "currentState": "JOB_STATE_RUNNING",
  "currentStateTime": "2020-08-27T16:08:57.060883Z",
  "environment": {
    "userAgent": {
      "container.version": "beam-master-20200227",
      "fnapi.environment.major.version": "8",
      "java.vendor": "Oracle Corporation",
      "java.version": "1.8.0_151",
      "legacy.environment.major.version": "8",
      "name": "Apache Beam SDK for Java",
      "os.arch": "amd64",
      "os.name": "Linux",
      "os.version": "4.14.150+",
      "support": {
        "status": "STALE",
        "url": "https://github.com/apache/beam/releases"
      },
      "version": "2.23.0-SNAPSHOT"
    },
    "version": {
      "job_type": "STREAMING",
      "major": "8"
    }
  },
  "id": "2020-08-27_09_07_26-10918414365182703414",
  "jobMetadata": {
    "sdkVersion": {
      "sdkSupportStatus": "STALE",
      "version": "2.23.0-SNAPSHOT",
      "versionDisplayName": "Apache Beam SDK for Java"
    }
  },
  "labels": {
    "goog-dataflow-sql-version": "20200212"
  },
  "location": "europe-west1",
  "name": "dfsql-test-dla",
  "projectId": "data-flow-test-dla",
  "stageStates": [
    {
      "currentStateTime": "2020-08-27T16:09:06.272Z",
      "executionStageName": "F19",
      "executionStageState": "JOB_STATE_RUNNING"
    },
    {
      "currentStateTime": "2020-08-27T16:09:06.272Z",
      "executionStageName": "F21",
      "executionStageState": "JOB_STATE_RUNNING"
    },
    {
      "currentStateTime": "2020-08-27T16:09:06.272Z",
      "executionStageName": "F20",
      "executionStageState": "JOB_STATE_RUNNING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "failure26",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "s16.output",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "start27",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "success25",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "teardown_resource_transactions.subscription-1493134922563805107124",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:09:06.272Z",
      "executionStageName": "F22",
      "executionStageState": "JOB_STATE_RUNNING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "s15.org.apache.beam.sdk.values.PCollection.<init>:400#56b99bb29b40d50c",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "s16",
      "executionStageState": "JOB_STATE_PENDING"
    },
    {
      "currentStateTime": "2020-08-27T16:08:58.239Z",
      "executionStageName": "setup_resource_transactions.subscription-1493134922563805107123",
      "executionStageState": "JOB_STATE_PENDING"
    }
  ],
  "startTime": "2020-08-27T16:07:27.037488Z",
  "type": "JOB_TYPE_STREAMING"
}
```
transactions_injector.py : alimente le topic

clean.sh : suppression des resources

# TO DO
- implement set_variable.sh : https://github.com/GoogleCloudPlatform/bigquery-data-lineage/blob/master/set_variables.sh
- complete "gcloud dataflow sql query" in order to avoid ressources leaks (staging bucket)
