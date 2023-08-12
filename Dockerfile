FROM openjdk:8u151-jdk-alpine
WORKDIR /home/app
ARG JAR_FILE=./build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENV  Dgrails.env=prod
ENTRYPOINT ["java","-Dgrails.env=prod","-jar","app.jar","--https"]
