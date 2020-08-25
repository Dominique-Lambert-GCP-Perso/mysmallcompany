SET GOOGLE_APPLICATION_CREDENTIALS=C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json

cd word-count-beam
mvn -Pdataflow-runner compile exec:java ^
      -Dexec.mainClass=org.apache.beam.examples.WordCount ^
      -Dexec.args="--project=data-flow-test-dla --stagingLocation=gs://cs-for-dataflow-dla/staging/ --output=gs://cs-for-dataflow-dla/output --gcpTempLocation=gs://cs-for-dataflow-dla/tmp/ --runner=DataflowRunner --region=europe-west1"