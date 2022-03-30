FROM openjdk:11-jdk

WORKDIR /home/
COPY ./target/chimera-tutorial-1.0.0.jar /home/chimera-tutorial-1.0.0.jar
COPY src/main/resources /home/
COPY lifting /home/
COPY lowering /home/

ENTRYPOINT ["java","-Xmx4g","-jar","/home/chimera-tutorial-1.0.0.jar"]
