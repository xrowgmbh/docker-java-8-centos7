# Spring Boot - Maven 3 - CentOS Docker image

This repository contains the sources and Dockerfile of the base image for building Spring Boot applications.

## Usage

To build a simple springboot-sample-app application using standalone S2I with Docker:

```sh
$ s2i build git://github.com/codecentric/springboot-sample-app xrowgmbh/docker-s2i-java-container --runtime-image=xrowgmbh/s2i-jre --runtime-artifact=/opt/app-root/src/target springboot-sample-app
```

## Repository organization

* **`s2i/bin/`**

  This folder contains scripts that are run by [S2I](https://github.com/openshift/source-to-image):

  *   **assemble**

      Is used to restore the build artifacts from the previous built (in case of
      'incremental build'), to install the sources into location from where the
      application will be run and prepare the application for deployment (eg.
      using maven to build the application etc..)

  *   **save-artifacts**

      In order to do an *incremental build* (iow. re-use the build artifacts
      from an already built image in a new image), this script is responsible for
      archiving those. In this image, this script will archive the
      `/opt/java/.m2` directory.

## Environment variables

*  **APP_ROOT** (default: '.')

    This variable specifies a relative location to your application inside the
    application GIT repository. In case your application is located in a
    sub-folder, you can set this variable to a *./myapplication*.

*  **APP_TARGET** (default: 'target')

    This variable specifies a relative location to your application binary inside the
    container.

*  **MVN_ARGS** (default: '')

    This variable specifies the arguments for Maven inside the container.

## Contributing

In order to test your changes to this STI image or to the STI scripts, you can use the `test/run` script. Before that, you have to build the 'candidate' image:

```
$ docker build -t codecentric/springboot-maven3-centos-candidate .
```

After that you can execute `./test/run`. You can also use `make test` to automate this.

## Copyright

Released under the Apache License 2.0. See the [LICENSE](https://github.com/codecentric/springboot-maven3-centos/blob/master/LICENSE) file.
