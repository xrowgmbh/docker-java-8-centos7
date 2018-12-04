# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Maven 3.

FROM centos/s2i-base-centos7

MAINTAINER Björn Dieding <bjoern@xrow.de>

EXPOSE 8080

ENV JAVA_VERSON=1.8.0 \
    MAVEN_VERSION=3.5.4

LABEL io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3,springboot" \
      io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Björn Dieding <bjoern@xrow.de>"

# Install Java, Maven, Wildfly
RUN INSTALL_PKGS="tar unzip bc which lsof ca-certificates java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/bin/mvn && \
    mkdir -p /opt/s2i/destination


ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/local/maven

# Add configuration files, bashrc and other tweaks
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
RUN /usr/bin/update-ca-trust force-enable && \
    /usr/bin/chmod +x $STI_SCRIPTS_PATH/* && \
    /usr/bin/chown -R 1001:0 ./ && \
    /usr/bin/chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage