SET GOOGLE_APPLICATION_CREDENTIALS=C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json

cd word-count-beam
mvn compile exec:java ^
	-Dexec.mainClass=org.apache.beam.examples.WordCount -Dexec.args="--output=counts"