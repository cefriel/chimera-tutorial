case "$1" in
        "--chimera")
		git clone --recurse-submodules https://github.com/cefriel/chimera.git
		cd chimera
		mvn clean
		mvn install -DskipTests
		cd ..
		mvn clean
		mvn install -DskipTests
        ;;
        "--build") 
		mvn clean
		mvn install -DskipTests
	;;
esac

mkdir execute
cp target/chimera-tutorial-1.0.0.jar execute/chimera-tutorial-1.0.0.jar
cp src/main/resources/routes/camel-context.xml execute/camel-context.xml
cp src/main/resources/ontology.owl execute/ontology.owl
cp src/main/resources/enrich.ttl execute/enrich.ttl
cp src/main/resources/construct.ttl execute/construct.ttl
cp lifting/mappings.rml.ttl execute/mappings.rml.ttl
cp lowering/template.vm execute/template.vm
cd execute
java -jar chimera-tutorial-1.0.0.jar
cd ..
rm -r execute