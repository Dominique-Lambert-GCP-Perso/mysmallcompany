SET GOOGLE_APPLICATION_CREDENTIALS=C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json

echo "Charger préalablement les données avec loaddata.sh"

cd word-count-beam

mvn -Pdataflow-runner compile exec:java ^
      -Dexec.mainClass=org.apache.beam.examples.WordCount ^
      -Dexec.args="--project=data-flow-test-dla --stagingLocation=gs://cs-for-dataflow-dla/staging/ --output=gs://cs-for-dataflow-dla/output --inputFile=gs://cs-for-dataflow-dla/input/input_Eat_pray_love.txt --gcpTempLocation=gs://cs-for-dataflow-dla/tmp/ --runner=DataflowRunner --region=europe-west1"