# Spring Boot layered DockerFile

Every time a build runs a layer with all the dependencies is created. This increases the storage size required to store versioned images. To solve this Spring boot offers a 'layered jar' feature.

This example shows how to create docker layers for your spring boot app. Use 'dive' to inspect the final image.

See: 

* https://spring.io/blog/2020/01/27/creating-docker-images-with-spring-boot-2-3-0-m1
* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
* https://docs.spring.io/spring-boot/docs/2.3.0.M1/gradle-plugin/reference/html/#packaging-layered-jars
* https://github.com/wagoodman/dive

## TL;DR

Each Docker instruction creates one layer:

* FROM creates a layer from the ubuntu:18.04 Docker image.
* COPY adds files from your Docker client’s current directory.
* RUN builds your application with make.
* CMD specifies what command to run within the container.


Combine Docker instructions:

```DockerFile
RUN apt-get update && apt-get install -y \
  bzr \
  cvs \
  git \
  mercurial \
  subversion \
  && rm -rf /var/lib/apt/lists/*
```

Maven:

```XML
<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
			<configuration>
				<layout>LAYERED_JAR</layout>
			</configuration>
		</plugin>
	</plugins>
</build>
```

Gradle:

```kotlin
tasks.getByName<BootJar>("bootJar") {
    layered()
}
```


DockerFile:

```DockerFile
FROM adoptopenjdk:11-jre-hotspot as builder
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM adoptopenjdk:11-jre-hotspot
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/resources/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
```

Dive:

```
dive <your-image-tag>
```

