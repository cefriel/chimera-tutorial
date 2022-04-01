FROM cefriel/chimera:tutorial

WORKDIR /home/
COPY camel-context.xml /home/routes/camel-context.xml

EXPOSE 8888

ENTRYPOINT ["java","-Xmx4g","-jar","/home/chimera-tutorial.jar"]

