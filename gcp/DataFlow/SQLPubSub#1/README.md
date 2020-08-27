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


