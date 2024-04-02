FROM maven:3.9.6-eclipse-temurin-17 as builder

WORKDIR /
COPY . /usr/src/chimera-tutorial

# Install example
WORKDIR /usr/src/chimera-tutorial
RUN mvn clean install -DskipTests

FROM eclipse-temurin:17
COPY --from=builder /usr/src/chimera-tutorial/target/chimera-tutorial.jar /home/chimera-tutorial.jar
COPY ./inbox/ /home/inbox/
COPY ./mappings/ /home/mappings/
COPY ./queries/ /home/queries/
COPY ./ontologies/ /home/ontologies/
COPY ./shacl-shapes/ /home/shacl-shapes/

ENTRYPOINT ["java","-Xmx4g","-jar","/home/chimera-tutorial.jar"]