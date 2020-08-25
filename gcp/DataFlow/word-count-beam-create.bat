SET GOOGLE_APPLICATION_CREDENTIALS=C:\Users\Utilisateur\cles\data-flow-test-dla-0b411f30ff7a.json

mvn archetype:generate -DarchetypeGroupId=org.apache.beam -DarchetypeArtifactId=beam-sdks-java-maven-archetypes-examples -DarchetypeVersion=2.23.0 -DgroupId=org.example -DartifactId=word-count-beam -Dversion="0.1" -Dpackage=org.apache.beam.examples -DinteractiveMode=false