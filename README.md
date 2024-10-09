# Project Documentation

# Project Overview

This project is a Java microservice application built using Spring Boot. The project is structured to support continuous integration and deployment using GitHub Actions and Docker. The application is designed to be deployed on AWS Elastic Beanstalk.

## Project Structure

.github/
    workflows/
        ci.yml
Dockerfile
java-pipeline/
    .dockerignore
    .elasticbeanstalk/
        config.yml
    .gitignore
    .mvn/
        wrapper/
            maven-wrapper.properties
    Dockerrun.aws.json
    mvnw
    mvnw.cmd
    pom.xml
    src/
        main/
            java/
                com/
                    devops/
                        java_pipeline/
                            Controllers/
                            JavaPipelineApplication.java
                            Model/
                            Repository/
                            Services/
            resources/
                application.properties
        test/
            java/
                com/
                    devops/
                        java_pipeline/
                            JavaPipelineApplicationTests.java```
How to Start Up
Prerequisites
- Java 17
- Docker
- Maven

Steps

1. Clone the repository:
    ```
    git clone <repository-url>
    cd java-pipeline    
    ```
2. Build the project

    ```
    ./mvnw clean install
    ```
3. Run the application
    ```
    ./mvnw spring-boot:run
    ```
4. Access the application: Open your browser and navigate to http://localhost:8080.


## GitHub Actions Pipeline
The GitHub Actions pipeline is defined in ```ci.yml```. This pipeline automates the build, test, and deployment processes.

Workflow Overview
- Trigger: The workflow is triggered on a push to the main branch.
- Environment Variables: Several environment variables are set using GitHub secrets and repository variables.

## Jobs
### Build Job
- Runs on: ubuntu-22.04
- Environment Variables:
    - MODULE_FULLNAME: Combines PROJECT_NAME and MODULE_NAME.
    - REGISTRY_URL: Constructs the Docker registry URL using AWS account ID and region

## Steps

 1. Checkout Code:
```yaml
- name: Checkout code
  uses: actions/checkout@v4
```
2. Setup JDK 17:
```yaml
- name: Setup JDK 17
  uses: actions/setup-java@v4
  with:
    distribution: 'corretto'
    java-version: '17'
```
3. Build Docker Image:
```yaml
- run: docker build -t $MODULE_FULLNAME $MODULE_NAME
```
4. Tag Docker Image:
```yaml
- run: docker tag $MODULE_FULLNAME:$TAG $REGISTRY_URL/$MODULE_FULLNAME:$TAG
```
5. Authenticate Docker to AWS ECR:
```yaml
- name: Authenticate Docker to AWS ECR
  run: |
    aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $REGISTRY_URL
```
6. Push Docker Image to AWS ECR:
```yaml
- name: Push Docker image to AWS ECR
  run: docker push $REGISTRY_URL/$MODULE_FULLNAME:$TAG
```
7. Upload Artifact:
```yaml
- name: Uploading artifact
  uses: actions/upload-artifact@v4
  with:
    name: ebconfig
    path: |
      java-pipeline/.elasticbeanstalk/config.yml
      java-pipeline/Dockerrun.aws.config.json
```