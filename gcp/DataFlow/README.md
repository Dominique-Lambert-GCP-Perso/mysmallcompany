# DataFlow

## Apache Beam Sources Quistart-java
https://beam.apache.org/get-started/quickstart-java/

Direct-runner : OK

dataflow-runner : ligne de commande légerement différentes de la documentation  (-Pdataflow-runner passé sur mvn)

Projet GCP : msc-network-tests
Storage : gs://word-count-dla

```Shell
mvn -Pdataflow-runner compile exec:java -D exec.mainClass=org.apache.beam.examples.WordCount `
		-D exec.args="--runner=DataflowRunner --project=msc-network-tests `
					  --gcpTempLocation=gs://word-count-dla/tmp `
					  --inputFile=gs://apache-beam-samples/shakespeare/* `
					  --output=gs://word-count-dla/counts"
```

## Dataflow Java et Eclipse 
https://cloud.google.com/dataflow/docs/quickstarts/quickstart-java-eclipse?hl=fr

Utilisation du plugin Cloud Tools for Eclipse (Java)
Projet java : WordCount avec utilisation du package : com.google.cloud.dataflow.examples.WordCount

Difficulté : la package semble de pas reconnaitre le gcpTempLocation s'il ne comprend pas 2 sous répertoires dans le bucket (issue connue sur le net) 

Fonctionne avec les paramètres suivants (run configuration)

```Shell
--output=gs://wordcount-mysmallcompany/counts 
--inputFile=gs://wordcount-mysmallcompany/input/* 
--gcpTempLocation=gs://wordcount-mysmallcompany/tmp/tmp
```

Test : Réaliser le comptage sur l'ensemble des mots du livre Eat pray and love (Elisabeth Gilbert) => voir data/

Points à creuser :
Infra
- utiliser les autres exemples fournit dans le package d'exemples
- modifier les paramètre d'appel pour ne plus traiter sur une zone US
- est-ce qu'il est possible de déposer le package de traitement dans un bucket local pour ne pas avoir à le rebuilder et relancer depuis Eclipse

Application
- passer en minuscule avant le comptage
- exploiter les données dans une application front à partir d'une base StorageData
