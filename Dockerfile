# springboot-maven3-centos
#
# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Maven 3.

FROM centos/s2i-core-centos7

EXPOSE 8080

ENV JAVA_VERSON=1.8.0 \
    MAVEN_VERSION=3.3.9 \
    JAVA_HOME=/usr/lib/jvm/java \
    MAVEN_HOME=/usr/share/maven

LABEL io.k8s.description="Platform for building Spring Boot applications" \
      io.k8s.display-name="Spring Boot Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3,springboot"

RUN yum install -y curl java-$JAVA_VERSON-openjdk-devel && \
    yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
RUN /usr/bin/chmod +x $STI_SCRIPTS_PATH/* && \
    /usr/bin/chown -R 1001:0 ./
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
