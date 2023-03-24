FROM maven:3.8.3-openjdk-17 as builder

WORKDIR /usr/src/deps
# Install dependencies
RUN git clone https://github.com/cefriel/chimera.git 

WORKDIR /usr/src/deps/chimera
RUN git submodule init
RUN git submodule update --remote --merge
RUN mvn clean install -DskipTests
# RUN sleep 10000000000

WORKDIR /
COPY . /usr/src/camel-yaml

# Install example
WORKDIR /usr/src/camel-yaml
RUN mvn clean install

FROM openjdk:17-jdk
COPY --from=builder /usr/src/camel-yaml/target/chimera-tutorial.jar /home/chimera-tutorial.jar
COPY ./inbox/ /home/inbox/
COPY ./mappings/ /home/mappings/
COPY ./queries/ /home/queries/
COPY ./ontologies/ /home/ontologies/
COPY ./shacl-shapes/ /home/shacl-shapes/

ENTRYPOINT ["java","-Xmx4g","-jar","/home/chimera-tutorial.jar"]

# RUN sleep 10000000000
