# DataFlow

## Apache Beam Sources Quistart-java
https://beam.apache.org/get-started/quickstart-java/

Direct-runner : OK

dataflow-runner : ligne de commande légèrement différente de la documentation  (-Pdataflow-runner passé sur mvn)

Projet GCP : msc-network-tests
Storage : gs://word-count-dla

```Shell
mvn -Pdataflow-runner compile exec:java -D exec.mainClass=org.apache.beam.examples.WordCount `
		-D exec.args="--runner=DataflowRunner --project=msc-network-tests `
					  --gcpTempLocation=gs://word-count-dla/tmp `
					  --inputFile=gs://apache-beam-samples/shakespeare/* `
					  --output=gs://word-count-dla/counts"
```