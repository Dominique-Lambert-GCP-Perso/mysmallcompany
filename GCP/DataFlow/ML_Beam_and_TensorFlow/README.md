# DataFlow 

## Apache Beam Sources Quistart-java
https://beam.apache.org/get-started/quickstart-java/

word-count-beam-create.bat : création du projet avec maven 

word-count-beam-run-local : lancement de word count en local (direct-runner par défaut)
```Shell
mvn compile exec:java ^
	-Dexec.mainClass=org.apache.beam.examples.WordCount -Dexec.args="--output=counts"
```

word-count-beam-run-dataflow.bat
Projet GCP : data-flow-test-dla
deploy.sh : création du projet et des bucket

Créer un compte de service : "data-flow-test-dla", appliquer le rôle owner (à afinner). 
Attention : Le téléchargement s'obtient avec le bouton créer sur la clé existante (ou via gcloud iam)
```Shell
gcloud iam service-accounts keys create my-data-flow-service-account.json --iam-account my-data-flow-service-account@data-flow-test-dla.iam.gserviceaccount.com
```


Depuis un poste sous Windows il faut setter la variable locale GOOGLE_APPLICATION_CREDENTIALS
```Shell
SET GOOGLE_APPLICATION_CREDENTIALS=C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json
```

```Shell
mvn -Pdataflow-runner compile exec:java ^
      -Dexec.mainClass=org.apache.beam.examples.WordCount ^
      -Dexec.args="--project=data-flow-test-dla --stagingLocation=gs://cs-for-dataflow-dla/staging/ --output=gs://cs-for-dataflow-dla/output --gcpTempLocation=gs://cs-for-dataflow-dla/output/tmp/ --runner=DataflowRunner --region=europe-west1"
```

clean.sh

## Dataflow Java et Eclipse 
https://cloud.google.com/dataflow/docs/quickstarts/quickstart-java-eclipse?hl=fr

Utilisation du plugin Cloud Tools for Eclipse (Java)
Projet java : WordCount avec utilisation du package : com.google.cloud.dataflow.examples.WordCount

- Importer le projet  de .POM
- Paramètre depuis "Run configuration"
- Goals : -Pdataflow-runner compile exec:java
- Paramètre :
	- exec.mainClass : org.apache.beam.examples.WordCount
	- exec.args : --project=data-flow-test-dla --stagingLocation=gs://cs-for-dataflow-dla/staging/ --output=gs://cs-for-dataflow-dla/output --gcpTempLocation=gs://cs-for-dataflow-dla/output/tmp/ --runner=DataflowRunner --region=europe-west1
- Environnement :
	- GOOGLE_APPLICATION_CREDENTIALS : C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json
	

Test : Réaliser le comptage sur l'ensemble des mots du livre Eat pray and love (Elisabeth Gilbert) 
load data.sh : charge les données depuis data/

word-count-beam-run-dataflow-inputFile.bat : lance word count avec les données chargée

```Shell
mvn -Pdataflow-runner compile exec:java ^
      -Dexec.mainClass=org.apache.beam.examples.WordCount ^
      -Dexec.args="--project=data-flow-test-dla --stagingLocation=gs://cs-for-dataflow-dla/staging/ --output=gs://cs-for-dataflow-dla/output --inputFile=gs://cs-for-dataflow-dla/input/input_Eat_pray_love.txt --gcpTempLocation=gs://cs-for-dataflow-dla/tmp/ --runner=DataflowRunner --region=europe-west1"
```

Application
- passer en minuscule avant le comptage
- exploiter les données dans une application front à partir d'une base StorageData
