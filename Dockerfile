FROM openjdk:17-jdk-alpine
LABEL authors="Kaburaru"

WORKDIR /app

COPY . .

RUN ./mvnw clean package -DskipTests


EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/java-microservice-0.0.1-SNAPSHOT.jar"]