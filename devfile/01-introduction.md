What is a devfile
=================

You can use devfiles to automate and simplify your development process by adopting the existing devfiles that are available in the [public community registry](https://registry.devfile.io/viewer) or by authoring your own devfiles to record custom instructions to configure and run your build environment as a YAML-formatted text file. You can make these devfiles available in the supporting build tools and IDEs that can automatically process the devfile instructions to configure and build a running application from a development project.

Using the recommended best practices from the devfile, the tools and IDE can:

*   Take in the repository hosting your application source code.
    
*   Build your code.
    
*   Run your application on your local container.
    
*   Deploy your application to cloud-native containers.


Benefits of devfile
===================

Why devfiles?
-------------

With devfiles, you can make workspaces composed of multiple containers. In these containers, you can create any number of identical workspaces from the same devfile. If you create multiple workspaces, you can share your devfile with different teams. By sharing a single devfile across multiple teams, you can ensure that each team has the same user experience and build, run, deploy behaviors.

Devfiles include the following features:

*   Guidance for using runtime images
    
*   Example code
    
*   Build and CI commands
    
*   Deployment options
    

Devfiles have the following benefits:

*   Reduce the gap between development and deployment
    
*   Find available devfile stacks or samples in a devfile registry
    
*   Produce consistent build and run behaviors
    

Who is devfile for?
-------------------

*   Application developers
*   Enterprise architects and runtime providers
*   Registry administrators
*   Technology and tool builders


Devfile ecosystem
=================

Create, Share and Consume Devfiles
----------------------------------

Organizations looking to standardize their development environment can do so by adopting devfiles. In the simplest case, developers can just consume the devfiles that are available from the public community registry. If your organization needs custom devfiles that are authored and shared internally, then you need a role based approach so developers, devfile authors, and registry administrators can interact together.

Devfile Ecosystem overview

### Create

A devfile author, also known as a runtime provider, can be an individual or a group representing a runtime vendor. Devfile authors need sound knowledge of the supported runtime so they can create devfiles to build and run applications.

If a runtime stack is not available in the public registry, an organization can choose to develop their own and keep it private for their in-house development.

### Share

The public community registry is managed by the community and hosted by Red Hat. Share your devfile to the public community registry so other teams can benefit from your application.

If an organization wants to keep their own devfiles private but wishes to share with other departments, they can assign a registry administrator. The registry administrator deploys, maintains, and manages the contents of their private registry and the default list of devfile registries available in a given cluster.


### Consume

Developers can use the supported tools to access devfiles. Many of the existing tools offer a way to register or catalog public and private devfile registries which then allows the tool to expose the devfiles for development.

In addition, each registry comes packaged with an index server and a registry viewer so developers can browse and view the devfile contents before deciding which ones they want to adopt.

Developers can also extend an existing parent devfile to customize the workflow of their specific application. The devfile can be packaged as part of the application source to ensure consistent behavior when moving across different tools.


Note!

Tools that support the devfile spec might have varying levels of support. Check their product pages for more information.


Understanding a devfile registry
================================

A devfile registry is a service that stores and provides devfile stacks to Kubernetes developer tools like `odo`, Eclipse Che, and the OpenShift Developer Console. Therefore, you can access devfiles through the devfile registry. Devfile registries are based on the Open Container Initiative (OCI) Specification, and devfile stacks are stored as OCI artifacts in the registry.

Each devfile stack corresponds to a specific runtime or framework, such as Node.js, Quarkus, or WildFly. A devfile stack also contains resources like a `devfile.yaml` file, logo, and outer loop resources. Outer loop runs on containers and entails code reviews and integration tests, typically automated by continuous integration/continuous delivery (CI/CD) pipelines. These devfile stacks provide developers with templates to get started developing cloud-native applications.

Devfile registry components
---------------------------

A devfile registry has two components:

*   Devfile index server
    
*   OCI registry server
    

### Devfile index container

The devfile index container image does the following actions:

*   Uses the `index.json` file to obtain metadata about the stacks and samples and hosts this metadata in the registry for tools to consume.
    
*   Bootstraps the OCI registry with the devfile stacks.
    
*   Provides an API to interact with the OCI registry and to retrieve devfile stacks.
    

### OCI registry

The devfile stacks in a devfile registry are stored in an OCI-compatible artifact registry. The artifact registry is based on the reference implementation of an OCI registry.

When a devfile registry is deployed, the stacks belonging to the devfile registry are pushed to the OCI registry as multi-layer artifacts.

Types of devfile registries
---------------------------

There are multiple types of devfile registries to access devfile stacks and tools.

### Public community registry

The public community registry provides stacks for various community tools to consume, such as Node.js, Quarkus, and Open Liberty.

Locate the source for the stacks in the public community registry in the [devfile/registry repository](https://github.com/devfile/registry).

### On-cluster devfile registry

Devfile registries can be operated on private Kubernetes clusters, deployed using either the devfile registry Operator or the devfile registry Helm Chart.

The on-cluster devfile registries can be configured with custom devfile stacks suited to the needs of the owner organization.

Devfile samples
================================

Sample devfile for .NET 5.0
```yaml
schemaVersion: 2.3.0
metadata:
  name: dotnet50
  displayName: .NET 5.0
  description: .NET 5.0 application
  icon: https://github.com/dotnet/brand/raw/main/logo/dotnet-logo.png
  tags:
    - .NET
    - .NET 5.0
  projectType: dotnet
  language: .NET
  version: 1.0.4
starterProjects:
  - name: dotnet50-example
    git:
      checkoutFrom:
        remote: origin
        revision: dotnet-5.0
      remotes:
        origin: https://github.com/redhat-developer/s2i-dotnetcore-ex
    subDir: app
components:
  - name: dotnet
    container:
      image: registry.access.redhat.com/ubi8/dotnet-50:5.0-39
      args: ["tail", "-f", "/dev/null"]
      mountSources: true
      env:
        - name: CONFIGURATION
          value: Debug
        - name: STARTUP_PROJECT
          value: app.csproj
        - name: ASPNETCORE_ENVIRONMENT
          value: Development
        - name: ASPNETCORE_URLS
          value: http://*:8080
      endpoints:
        - name: https-dotnet50
          protocol: https
          targetPort: 8080
commands:
  - id: build
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: kill $(pidof dotnet); dotnet build -c $CONFIGURATION $STARTUP_PROJECT /p:UseSharedCompilation=false
      component: dotnet
      group:
        isDefault: true
        kind: build
  - id: run
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: dotnet run -c $CONFIGURATION --no-build --project $STARTUP_PROJECT --no-launch-profile
      component: dotnet
      group:
        isDefault: true
        kind: run
```
Sample devfile for .NET 6.0
```yaml
schemaVersion: 2.3.0
metadata:
  name: dotnet60
  displayName: .NET 6.0
  description: .NET 6.0 application
  icon: https://github.com/dotnet/brand/raw/main/logo/dotnet-logo.png
  tags:
    - .NET
    - .NET 6.0
  projectType: dotnet
  language: .NET
  version: 1.0.3
starterProjects:
  - name: dotnet60-example
    git:
      checkoutFrom:
        remote: origin
        revision: dotnet-6.0
      remotes:
        origin: https://github.com/redhat-developer/s2i-dotnetcore-ex
    subDir: app
components:
  - name: dotnet
    container:
      image: registry.access.redhat.com/ubi8/dotnet-60:6.0-56
      args: ["tail", "-f", "/dev/null"]
      mountSources: true
      env:
        - name: CONFIGURATION
          value: Debug
        - name: STARTUP_PROJECT
          value: app.csproj
        - name: ASPNETCORE_ENVIRONMENT
          value: Development
        - name: ASPNETCORE_URLS
          value: http://*:8080
      endpoints:
        - name: https-dotnet60
          protocol: https
          targetPort: 8080
commands:
  - id: build
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: kill $(pidof dotnet); dotnet build -c $CONFIGURATION $STARTUP_PROJECT /p:UseSharedCompilation=false
      component: dotnet
      group:
        isDefault: true
        kind: build
  - id: run
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: dotnet run -c $CONFIGURATION --no-build --project $STARTUP_PROJECT --no-launch-profile
      component: dotnet
      group:
        isDefault: true
        kind: run
```
Sample devfile for .NET 8.0
```yaml
schemaVersion: 2.2.2
metadata:
  name: dotnet80
  displayName: .NET 8.0
  description: .NET 8.0 application
  icon: https://github.com/dotnet/brand/raw/main/logo/dotnet-logo.png
  tags:
    - .NET
    - .NET 8.0
  projectType: dotnet
  language: .NET
  version: 1.0.0
starterProjects:
  - name: dotnet80-example
    git:
      checkoutFrom:
        remote: origin
        revision: dotnet-8.0
      remotes:
        origin: https://github.com/redhat-developer/s2i-dotnetcore-ex
    subDir: app
components:
  - name: dotnet
    container:
      image: registry.access.redhat.com/ubi8/dotnet-80:8.0-13
      args: ["tail", "-f", "/dev/null"]
      mountSources: true
      env:
        - name: CONFIGURATION
          value: Debug
        - name: STARTUP_PROJECT
          value: app.csproj
        - name: ASPNETCORE_ENVIRONMENT
          value: Development
        - name: ASPNETCORE_URLS
          value: http://*:8080
      endpoints:
        - name: https-dotnet80
          protocol: https
          targetPort: 8080
commands:
  - id: build
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: kill $(pidof dotnet); dotnet build -c $CONFIGURATION $STARTUP_PROJECT /p:UseSharedCompilation=false
      component: dotnet
      group:
        isDefault: true
        kind: build
  - id: run
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: dotnet run -c $CONFIGURATION --no-build --project $STARTUP_PROJECT --no-launch-profile
      component: dotnet
      group:
        isDefault: true
        kind: run
```
Sample devfile for .NET Core 3.1
```yaml
schemaVersion: 2.2.2
metadata:
  name: dotnetcore31
  displayName: .NET Core 3.1
  description: .NET Core 3.1 application
  icon: https://github.com/dotnet/brand/raw/main/logo/dotnet-logo.png
  tags:
    - .NET
    - .NET Core App 3.1
  projectType: dotnet
  language: .NET
  version: 1.0.3
starterProjects:
  - name: dotnetcore-example
    git:
      checkoutFrom:
        remote: origin
        revision: dotnetcore-3.1
      remotes:
        origin: https://github.com/redhat-developer/s2i-dotnetcore-ex
    subDir: app
components:
  - name: dotnet
    container:
      image: registry.access.redhat.com/ubi8/dotnet-31:3.1-61
      args: ["tail", "-f", "/dev/null"]
      mountSources: true
      env:
        - name: CONFIGURATION
          value: Debug
        - name: STARTUP_PROJECT
          value: app.csproj
        - name: ASPNETCORE_ENVIRONMENT
          value: Development
        - name: ASPNETCORE_URLS
          value: http://*:8080
      endpoints:
        - name: https-dotnet
          protocol: https
          targetPort: 8080
commands:
  - id: build
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: kill $(pidof dotnet); dotnet build -c $CONFIGURATION $STARTUP_PROJECT /p:UseSharedCompilation=false
      component: dotnet
      group:
        isDefault: true
        kind: build
  - id: run
    exec:
      workingDir: ${PROJECT_SOURCE}
      commandLine: dotnet run -c $CONFIGURATION --no-build --project $STARTUP_PROJECT --no-launch-profile
      component: dotnet
      group:
        isDefault: true
        kind: run
```
Sample devfile for Go Runtime
```yaml
schemaVersion: 2.3.0
metadata:
  name: go
  displayName: Go Runtime
  description: Go (version 1.19.x) is an open source programming language that makes it easy to build simple, reliable, and efficient software.
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/golang.svg
  tags:
    - Go
  projectType: Go
  language: Go
  provider: Red Hat
  version: 1.2.1
starterProjects:
  - name: go-starter
    description: A Go project with a simple HTTP server
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-go.git
components:
  - container:
      endpoints:
        - name: https-go
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      image: registry.access.redhat.com/ubi9/go-toolset:1.19.13-4.1697647145
      args: ["tail", "-f", "/dev/null"]
      env:
        - name: DEBUG_PORT
          value: '5858'
      memoryLimit: 1024Mi
      mountSources: true
    name: runtime
commands:
  - exec:
      env:
        - name: GOPATH
          value: ${PROJECT_SOURCE}/.go
        - name: GOCACHE
          value: ${PROJECT_SOURCE}/.cache
      commandLine: go build main.go
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: build
  - exec:
      commandLine: ./main
      component: runtime
      group:
        isDefault: true
        kind: run
      workingDir: ${PROJECT_SOURCE}
    id: run
  - exec:
      env:
        - name: GOPATH
          value: ${PROJECT_SOURCE}/.go
        - name: GOCACHE
          value: ${PROJECT_SOURCE}/.cache
      commandLine: |
        dlv \
          --listen=127.0.0.1:${DEBUG_PORT} \
          --only-same-user=false \
          --headless=true \
          --api-version=2 \
          --accept-multiclient \
          debug --continue main.go
      component: runtime
      group:
        isDefault: true
        kind: debug
      workingDir: ${PROJECT_SOURCE}
    id: debug
```
Sample devfile for Maven Java
```yaml
schemaVersion: 2.2.2
metadata:
  name: java-maven
  displayName: Maven Java
  description: Java application based on Maven 3.8 and OpenJDK 17
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/java-maven.jpg
  tags:
    - Java
    - Maven
  projectType: Maven
  language: Java
  version: 1.3.1
starterProjects:
  - name: springbootproject
    git:
      remotes:
        origin: 'https://github.com/devfile-samples/springboot-ex.git'
components:
  - name: tools
    container:
      image: registry.access.redhat.com/ubi9/openjdk-17:1.20-2.1721752931
      command: ["tail", "-f", "/dev/null"]
      memoryLimit: 512Mi
      mountSources: true
      endpoints:
        - name: https-maven
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      volumeMounts:
        - name: m2
          path: /home/user/.m2
      env:
        - name: DEBUG_PORT
          value: '5858'
  - name: m2
    volume: {}
commands:
  - id: mvn-package
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'mvn -Dmaven.repo.local=/home/user/.m2/repository package'
      group:
        kind: build
        isDefault: true
  - id: run
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'java -jar target/*.jar'
      group:
        kind: run
        isDefault: true
  - id: debug
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=${DEBUG_PORT},suspend=n -jar target/*.jar'
      group:
        kind: debug
        isDefault: true
```
Sample devfile for Open Liberty Gradle
```yaml
# Copyright (c) 2021,2022 IBM Corporation and others
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

schemaVersion: 2.2.2
metadata:
  name: java-openliberty-gradle
  displayName: Open Liberty Gradle
  description: Java application based on Java 11, Gradle using the Open Liberty runtime 22.0.0.1
  icon: https://raw.githubusercontent.com/OpenLiberty/logos/7fbb132949b9b2589e18c8d5665c1b107028a21d/logomark/svg/OL_logomark.svg
  tags:
    - Java
    - Gradle
  architectures:
    - amd64
    - ppc64le
    - s390x
  projectType: Open Liberty
  language: Java
  version: 0.5.0
  alpha.build-dockerfile: https://github.com/OpenLiberty/devfile-stack/releases/download/open-liberty-gradle-0.3.1/Dockerfile
  alpha.deployment-manifest: https://github.com/OpenLiberty/devfile-stack/releases/download/open-liberty-gradle-0.3.1/app-deploy.yaml
starterProjects:
  - name: rest
    git:
      remotes:
        origin: 'https://github.com/OpenLiberty/devfile-stack-starters.git'
variables:
  # Liberty runtime version. Minimum recommended: 21.0.0.9
  liberty-version: '22.0.0.1'
  gradle-cmd: 'gradle'
components:
  - name: dev
    container:
      image: icr.io/appcafe/open-liberty-devfile-stack:{{liberty-version}}-gradle
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1280Mi
      mountSources: true
      endpoints:
        - exposure: public
          path: /
          name: https-gradle
          targetPort: 9080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: run
    exec:
      component: dev
      commandLine: echo "gradle run command"; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=openliberty-runtime -Pliberty.runtime.group=io.openliberty --libertyDebug=false --hotTests --compileWait=3
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: run-test-off
    exec:
      component: dev
      commandLine: echo "gradle run-tests-off command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=openliberty-runtime -Pliberty.runtime.group=io.openliberty --libertyDebug=false
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: false
  - id: debug
    exec:
      component: dev
      commandLine: echo "gradle debug command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=openliberty-runtime -Pliberty.runtime.group=io.openliberty --libertyDebugPort=${DEBUG_PORT} -Pliberty.server.env.WLP_DEBUG_REMOTE=y
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
  - id: test
    exec:
      component: dev
      commandLine: echo "gradle test command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle test -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=openliberty-runtime -Pliberty.runtime.group=io.openliberty
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: test
        isDefault: true
```
Sample devfile for Open Liberty Maven
```yaml
# Copyright (c) 2021,2022 IBM Corporation and others
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

schemaVersion: 2.2.2
metadata:
  name: java-openliberty
  displayName: Open Liberty Maven
  description: Java application based on Java 11 and Maven 3.8, using the Open Liberty runtime 22.0.0.1
  icon: https://raw.githubusercontent.com/OpenLiberty/logos/7fbb132949b9b2589e18c8d5665c1b107028a21d/logomark/svg/OL_logomark.svg
  tags:
    - Java
    - Maven
  architectures:
    - amd64
    - ppc64le
    - s390x
  projectType: Open Liberty
  language: Java
  version: 0.10.0
  alpha.build-dockerfile: https://github.com/OpenLiberty/devfile-stack/releases/download/open-liberty-maven-0.8.1/Dockerfile
  alpha.deployment-manifest: https://github.com/OpenLiberty/devfile-stack/releases/download/open-liberty-maven-0.8.1/app-deploy.yaml
starterProjects:
  - name: rest
    git:
      remotes:
        origin: https://github.com/OpenLiberty/devfile-stack-starters.git
variables:
  # Liberty runtime version. Minimum recommended: 21.0.0.9
  liberty-version: '22.0.0.1'
  liberty-plugin-version: '3.5.1'
  mvn-cmd: 'mvn'
components:
  - name: dev
    container:
      # In the original upstream of this devfile, the image used is openliberty/devfile-stack:<x.y.z>, which is built from the repository: https://github.com/OpenLiberty/devfile-stack
      image: icr.io/appcafe/open-liberty-devfile-stack:{{liberty-version}}
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 768Mi
      mountSources: true
      endpoints:
        - exposure: public
          path: /
          name: https-openlib
          targetPort: 9080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: run
    exec:
      component: dev
      commandLine: echo "run command "; {{mvn-cmd}} -DinstallDirectory=/opt/ol/wlp -Ddebug=false -DhotTests=true -DcompileWait=3 io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: run-test-off
    exec:
      component: dev
      commandLine: echo "run-test-off command "; {{mvn-cmd}} -DinstallDirectory=/opt/ol/wlp -Ddebug=false io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: false
  - id: debug
    exec:
      component: dev
      commandLine: echo "debug command "; {{mvn-cmd}} -DinstallDirectory=/opt/ol/wlp -DdebugPort=${DEBUG_PORT} io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev -Dliberty.env.WLP_DEBUG_REMOTE=y
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
  - id: test
    # The 'test' command requires an already active container. Multi-module apps require compilation prior to test processing.
    exec:
      component: dev
      commandLine: echo "test command "; {{mvn-cmd}} compiler:compile failsafe:integration-test failsafe:verify
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: test
        isDefault: true
```
Sample devfile for Quarkus Java
```yaml
schemaVersion: 2.3.0
metadata:
  name: java-quarkus
  displayName: Quarkus Java
  description: Java application using Quarkus and OpenJDK 21
  icon: https://design.jboss.org/quarkus/logo/final/SVG/quarkus_icon_rgb_default.svg
  tags:
    - Java
    - Quarkus
  projectType: Quarkus
  language: Java
  version: 1.5.0
  website: https://quarkus.io
starterProjects:
  - name: community
    zip:
      location: https://code.quarkus.io/d?e=io.quarkus%3Aquarkus-resteasy&e=io.quarkus%3Aquarkus-micrometer&e=io.quarkus%3Aquarkus-smallrye-health&e=io.quarkus%3Aquarkus-openshift&cn=devfile&j=21
  - name: redhat-product
    zip:
      location: https://code.quarkus.redhat.com/d?e=io.quarkus%3Aquarkus-resteasy&e=io.quarkus%3Aquarkus-smallrye-health&e=io.quarkus%3Aquarkus-openshift&j=21
components:
  - name: tools
    container:
      image: registry.access.redhat.com/ubi8/openjdk-21:1.20-3.1721207868
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi ## default app nowhere needs this but leaving room for expansion.
      mountSources: true
      volumeMounts:
        - name: m2
          path: /home/user/.m2
      endpoints:
        - name: https-quarkus
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
  - name: m2
    volume:
      size: 3Gi
commands:
  - id: init-compile
    exec:
      component: tools
      commandLine: './mvnw -Dmaven.repo.local=/home/user/.m2/repository compile'
      workingDir: ${PROJECT_SOURCE}
  - id: dev-run
    exec:
      component: tools
      commandLine: './mvnw -Dmaven.repo.local=/home/user/.m2/repository quarkus:dev -Dquarkus.http.host=0.0.0.0'
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
      workingDir: ${PROJECT_SOURCE}
  - id: dev-debug
    exec:
      component: tools
      commandLine: './mvnw -Dmaven.repo.local=/home/user/.m2/repository quarkus:dev -Dquarkus.http.host=0.0.0.0 -Ddebug=${DEBUG_PORT}'
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
      workingDir: ${PROJECT_SOURCE}
events:
  postStart:
    - init-compile
```
Sample devfile for Spring Boot®
```yaml
schemaVersion: 2.2.2
metadata:
  name: java-springboot
  displayName: Spring Boot®
  description: Java application using Spring Boot® and OpenJDK 17
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/spring.svg
  tags:
    - Java
    - Spring
  projectType: springboot
  language: Java
  version: 1.4.0
  globalMemoryLimit: 2674Mi
starterProjects:
  - name: springbootproject
    git:
      remotes:
        origin: "https://github.com/devfile-samples/springboot-ex.git"
components:
  - name: tools
    container:
      image: registry.access.redhat.com/ubi9/openjdk-17:1.20-2.1721752931
      command: ["tail", "-f", "/dev/null"]
      memoryLimit: 768Mi
      mountSources: true
      endpoints:
        - name: https-springbt
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      volumeMounts:
        - name: m2
          path: /home/user/.m2
      env:
        - name: DEBUG_PORT
          value: "5858"
  - name: m2
    volume:
      size: 3Gi
commands:
  - id: build
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: "mvn clean -Dmaven.repo.local=/home/user/.m2/repository package -Dmaven.test.skip=true"
      group:
        kind: build
        isDefault: true
  - id: run
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: "mvn -Dmaven.repo.local=/home/user/.m2/repository spring-boot:run"
      group:
        kind: run
        isDefault: true
  - id: debug
    exec:
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: "java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=${DEBUG_PORT},suspend=n -jar target/*.jar"
      group:
        kind: debug
        isDefault: true
```
Sample devfile for Vert.x Java
```yaml
schemaVersion: 2.2.2
metadata:
  name: java-vertx
  displayName: Vert.x Java
  description: Java application using Vert.x and OpenJDK 11
  icon: https://raw.githubusercontent.com/vertx-web-site/vertx-logo/master/vertx-logo.svg
  tags:
    - Java
    - Vert.x
  projectType: Vert.x
  language: Java
  version: 1.4.0
starterProjects:
  - name: vertx-http-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-http-example
  - name: vertx-istio-circuit-breaker-booster
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-istio-circuit-breaker-booster
  - name: vertx-istio-routing-booster
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-istio-routing-booster
  - name: vertx-secured-http-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-secured-http-example-redhat
  - name: vertx-crud-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-crud-example-redhat
  - name: vertx-istio-security-booster
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-istio-security-booster
  - name: vertx-crud-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-crud-example
  - name: vertx-circuit-breaker-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-circuit-breaker-example
  - name: vertx-configmap-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-configmap-example
  - name: vertx-circuit-breaker-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-circuit-breaker-example-redhat
  - name: vertx-cache-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-cache-example-redhat
  - name: vertx-cache-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-cache-example
  - name: vertx-secured-http-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-secured-http-example
  - name: vertx-health-checks-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-health-checks-example-redhat
  - name: vertx-http-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-http-example-redhat
  - name: vertx-health-checks-example
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-health-checks-example
  - name: vertx-configmap-example-redhat
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-configmap-example-redhat
  - name: vertx-messaging-work-queue-booster
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-messaging-work-queue-booster
  - name: vertx-istio-distributed-tracing-booster
    git:
      remotes:
        origin: https://github.com/openshift-vertx-examples/vertx-istio-distributed-tracing-booster
components:
  - name: runtime
    container:
      endpoints:
        - exposure: public
          path: /
          name: https-vertx
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      image: registry.access.redhat.com/ubi8/openjdk-11:1.21-1.1736337912
      command: ["tail", "-f", "/dev/null"]
      memoryLimit: 512Mi
      mountSources: true
      volumeMounts:
        - name: m2
          path: /home/user/.m2
      env:
        - name: DEBUG_PORT
          value: '5858'
  - name: m2
    volume:
      size: 3Gi
commands:
  - id: mvn-package
    exec:
      commandLine: mvn package -Dmaven.test.skip=true
      component: runtime
      workingDir: ${PROJECT_SOURCE}
      group:
        isDefault: true
        kind: build
  - id: run
    exec:
      commandLine: mvn io.reactiverse:vertx-maven-plugin:run
      component: runtime
      workingDir: ${PROJECT_SOURCE}
      group:
        isDefault: true
        kind: run
  - id: debug
    exec:
      commandLine: mvn io.reactiverse:vertx-maven-plugin:debug -Ddebug.port=${DEBUG_PORT}
      component: runtime
      workingDir: ${PROJECT_SOURCE}
      group:
        isDefault: true
        kind: debug
```
Sample devfile for WebSphere Liberty Gradle
```yaml
# Copyright (c) 2021,2022 IBM Corporation and others
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

schemaVersion: 2.2.2
metadata:
  name: java-websphereliberty-gradle
  displayName: WebSphere Liberty Gradle
  description: Java application based on Java 11 and Gradle, using the WebSphere Liberty runtime 22.0.0.1
  icon: https://raw.githubusercontent.com/WASdev/logos/main/liberty-was-500-purple.svg
  tags:
    - Java
    - Gradle
    - WebSphere Liberty
  architectures:
    - amd64
    - ppc64le
    - s390x
  projectType: WebSphere Liberty
  language: Java
  version: 0.5.0
  alpha.build-dockerfile: https://github.com/OpenLiberty/devfile-stack/releases/download/websphere-liberty-gradle-0.3.1/Dockerfile
  alpha.deployment-manifest: https://github.com/OpenLiberty/devfile-stack/releases/download/websphere-liberty-gradle-0.3.1/app-deploy.yaml
starterProjects:
  - name: rest
    git:
      remotes:
        origin: 'https://github.com/OpenLiberty/devfile-stack-starters.git'
variables:
  # Liberty runtime version. Minimum recommended: 21.0.0.9
  liberty-version: '22.0.0.1'
  gradle-cmd: 'gradle'
components:
  - name: dev
    container:
      image: icr.io/appcafe/websphere-liberty-devfile-stack:{{liberty-version}}-gradle
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1280Mi
      mountSources: true
      endpoints:
        - exposure: public
          path: /
          name: https-webgradle
          targetPort: 9080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: run
    exec:
      component: dev
      commandLine: echo "gradle run command"; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=wlp-javaee8 -Pliberty.runtime.group=com.ibm.websphere.appserver.runtime --libertyDebug=false --hotTests --compileWait=3
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: run-test-off
    exec:
      component: dev
      commandLine: echo "gradle run-tests-off command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=wlp-javaee8 -Pliberty.runtime.group=com.ibm.websphere.appserver.runtime --libertyDebug=false
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: false
  - id: debug
    exec:
      component: dev
      commandLine: echo "gradle debug command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle libertyDev -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=wlp-javaee8 -Pliberty.runtime.group=com.ibm.websphere.appserver.runtime --libertyDebugPort=${DEBUG_PORT} -Pliberty.server.env.WLP_DEBUG_REMOTE=y
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
  - id: test
    exec:
      component: dev
      commandLine: echo "gradle test command "; {{gradle-cmd}} -Dgradle.user.home=/.gradle test -Pliberty.runtime.version={{liberty-version}} -Pliberty.runtime.name=wlp-javaee8 -Pliberty.runtime.group=com.ibm.websphere.appserver.runtime
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: test
        isDefault: true
```
Sample devfile for WebSphere Liberty Maven
```yaml
# Copyright (c) 2021,2022 IBM Corporation and others
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

schemaVersion: 2.2.2
metadata:
  name: java-websphereliberty
  displayName: WebSphere Liberty Maven
  description: Java application based Java 11 and Maven 3.8, using the WebSphere Liberty runtime 22.0.0.1
  icon: https://raw.githubusercontent.com/WASdev/logos/main/liberty-was-500-purple.svg
  tags:
    - Java
    - Maven
    - WebSphere Liberty
  architectures:
    - amd64
    - ppc64le
    - s390x
  language: Java
  projectType: WebSphere Liberty
  version: 0.10.0
  alpha.build-dockerfile: https://github.com/OpenLiberty/devfile-stack/releases/download/websphere-liberty-maven-0.8.1/Dockerfile
  alpha.deployment-manifest: https://github.com/OpenLiberty/devfile-stack/releases/download/websphere-liberty-maven-0.8.1/app-deploy.yaml
starterProjects:
  - name: rest
    git:
      remotes:
        origin: 'https://github.com/OpenLiberty/devfile-stack-starters.git'
variables:
  # Liberty runtime version. Minimum recommended: 21.0.0.9
  liberty-version: '22.0.0.1'
  liberty-plugin-version: '3.5.1'
  mvn-cmd: 'mvn'
components:
  - name: dev
    container:
      # In the original upstream of this devfile, the image used is openliberty/devfile-stack:<x.y.z>, which is built from the repository: https://github.com/OpenLiberty/devfile-stack
      image: icr.io/appcafe/websphere-liberty-devfile-stack:{{liberty-version}}
      command: ['tail', '-f', '/dev/null']
      memoryLimit: 768Mi
      mountSources: true
      endpoints:
        - exposure: public
          path: /
          name: https-websphere
          targetPort: 9080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: run
    exec:
      component: dev
      commandLine: echo "run command "; {{mvn-cmd}} -DinstallDirectory=/opt/ibm/wlp -Ddebug=false -DhotTests=true -DcompileWait=3 io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: run-test-off
    exec:
      component: dev
      commandLine: echo "run-test-off command "; {{mvn-cmd}} -DinstallDirectory=/opt/ibm/wlp -Ddebug=false io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: false
  - id: debug
    exec:
      component: dev
      commandLine: echo "debug command "; {{mvn-cmd}} -DinstallDirectory=/opt/ibm/wlp -DdebugPort=${DEBUG_PORT} io.openliberty.tools:liberty-maven-plugin:{{liberty-plugin-version}}:dev -Dliberty.env.WLP_DEBUG_REMOTE=y
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
  - id: test
    # The 'test' command requires an already active container. Multi-module apps require compilation prior to test processing.
    exec:
      component: dev
      commandLine: echo "test command "; {{mvn-cmd}} compiler:compile failsafe:integration-test failsafe:verify
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: test
        isDefault: true
```
Sample devfile for WildFly Bootable Jar
```yaml
schemaVersion: 2.2.2
metadata:
  name: java-wildfly-bootable-jar
  displayName: WildFly Bootable Jar
  description: Java application using WildFly in bootable Jar mode, OpenJDK 11 and Maven 3.6
  icon: https://design.jboss.org/wildfly/logo/final/wildfly_logomark.svg
  tags:
    - RHEL8
    - Java
    - OpenJDK
    - Maven
    - WildFly
    - Microprofile
    - WildFly Bootable
  projectType: WildFly
  language: Java
  version: 1.3.0
  website: https://docs.wildfly.org/bootablejar/
starterProjects:
  - name: microprofile-config
    description: WildFly Eclipse Microprofile Config Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-config
  - name: microprofile-fault-tolerance
    description: WildFly Eclipse Microprofile Fault Tolerance Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-fault-tolerance
  - name: microprofile-health
    description: WildFly Eclipse Microprofile Health Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-health
  - name: microprofile-jwt
    description: WildFly Eclipse Microprofile JWT Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-jwt
  - name: microprofile-metrics
    description: WildFly Eclipse Microprofile Metrics Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-metrics
  - name: microprofile-openapi
    description: WildFly Eclipse Microprofile OpenAPI Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-openapi
  - name: microprofile-opentracing
    description: WildFly Eclipse Microprofile OpenTracing Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-opentracing
  - name: microprofile-rest-client
    description: WildFly Eclipse Microprofile REST Client Quickstart
    git:
      checkoutFrom:
        remote: wildfly-quickstart
        revision: 26.1.0.Final
      remotes:
        wildfly-quickstart: https://github.com/wildfly/quickstart.git
    subDir: microprofile-rest-client
components:
  - name: wildfly
    container:
      image: registry.access.redhat.com/ubi8/openjdk-11:1.21-1.1736337912
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1512Mi
      mountSources: true
      volumeMounts:
        - name: m2-repository
          path: /home/jboss/.m2/repository
      env:
        # Enabling Jaeger tracing
        - name: WILDFLY_TRACING_ENABLED
          value: 'true'
        # Define the Jaeger service name
        - name: JAEGER_SERVICE_NAME
          value: 'microprofile-opentracing'
        # Configure Jaeger traces
        - name: JAEGER_REPORTER_LOG_SPANS
          value: 'true'
        - name: JAEGER_SAMPLER_TYPE
          value: 'const'
        - name: JAEGER_SAMPLER_PARAM
          value: '1'
        - name: GC_METASPACE_SIZE
          value: '96'
        - name: GC_MAX_METASPACE_SIZE
          value: '256'
        - name: JAVA_OPTS
          value: '-Djava.security.egd=file:/dev/urandom'
        - name: MVN_ARGS_APPEND
          value: '-Pbootable-jar-openshift -Djkube.skip=true -s /home/jboss/.m2/settings.xml -Dmaven.repo.local=/home/jboss/.m2/repository -Dcom.redhat.xpaas.repo.jbossorg'
        - name: DEBUG_PORT
          value: '5858'
      endpoints:
        - name: https-wildjar
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
  - name: jaeger
    container:
      image: quay.io/jaegertracing/all-in-one:1.60
      memoryLimit: 128Mi
      endpoints:
        - name: tracing-ui-jar
          targetPort: 16686
  - name: m2-repository
    volume:
      size: 3Gi
commands:
  - id: build
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} clean package
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: false
  - id: run
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} org.wildfly.plugins:wildfly-jar-maven-plugin:run
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: run
        isDefault: false
  - id: debug
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} -Dwildfly.bootable.jvmArguments="-agentlib:jdwp=transport=dt_socket,address=0.0.0.0:${DEBUG_PORT},server=y,suspend=n" org.wildfly.plugins:wildfly-jar-maven-plugin:run
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: debug
        isDefault: false
  - id: dev-build
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} -Dmaven.test.skip=true -Ddev package
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: false
  - id: dev-run
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} org.wildfly.plugins:wildfly-jar-maven-plugin:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: false
  - id: dev-debug
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} -Dwildfly.bootable.jvmArguments="-agentlib:jdwp=transport=dt_socket,address=0.0.0.0:${DEBUG_PORT},server=y,suspend=n" org.wildfly.plugins:wildfly-jar-maven-plugin:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: false
  - id: watch-build
    exec:
      component: wildfly
      commandLine: echo 'It's watcher mode so we are doing nothing to build.''
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: true
  - id: watch-run
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} org.wildfly.plugins:wildfly-jar-maven-plugin:dev-watch -e -DskipTests
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: watch-debug
    exec:
      component: wildfly
      commandLine: mvn ${MVN_ARGS_APPEND} -Dwildfly.bootable.jvmArguments="-agentlib:jdwp=transport=dt_socket,address=0.0.0.0:${DEBUG_PORT},server=y,suspend=n" org.wildfly.plugins:wildfly-jar-maven-plugin:dev-watch -e
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
```
Sample devfile for WildFly Getting Started
```yaml
schemaVersion: 2.3.0
metadata:
  name: wildfly-start
  version: 2.0.2
  website: https://wildfly.org
  displayName: WildFly Getting Started
  description: Upstream WildFly Getting Started
  icon: https://design.jboss.org/wildfly/logo/final/wildfly_logomark.svg
  tags: ['Java', 'WildFly']
  projectType: 'wildfly'
  language: Java
variables:
  applicationName: 'start'
  nodeName: 'getting-started'
starterProjects:
  - name: getting-started
    description: WildFly Getting Started
    git:
      checkoutFrom:
        remote: wildfly-devfile-examples
        revision: getting-started-2.0.2
      remotes:
        wildfly-devfile-examples: https://github.com/wildfly-extras/wildfly-devfile-examples.git
components:
  - name: tools
    container:
      image:  quay.io/devfile/universal-developer-image:ubi8-latest
      memoryLimit: 1512Mi
      mountSources: true
      volumeMounts:
        - name: m2
          path: /home/user/.m2
      env:
        - name: JAVA_OPTS
          value: '-Djava.security.egd=file:/dev/urandom -Djboss.host.name=localhost'
        - name: DEBUG_PORT
          value: '5005'
        - name: NODE_NAME
          value: '{{nodeName}}'
        - name: IMAGE
          value: '{{imageName}}'
      endpoints:
        - name: debug
          exposure: internal
          protocol: tcp
          targetPort: 5005
        - name: 'http'
          protocol: https
          targetPort: 8080
          exposure: public
        - name: 'management'
          targetPort: 9990
          protocol: http
          exposure: internal
  - name: m2
    volume:
      size: 3Gi
commands:
  - id: package
    exec:
      label: "01 - Build the application."
      component: tools
      commandLine: mvn clean verify
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: build
        isDefault: true
  - id: run
    exec:
      label: "02 - Run the application in dev mode."
      component: tools
      commandLine: mvn -Dwildfly.javaOpts="-Djboss.host.name=${NODE_NAME}" -Dmaven.test.skip=true clean package org.wildfly.plugins:wildfly-maven-plugin:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: run
        isDefault: true
  - id: debug
    exec:
      label: "03 - Debug the application in dev mode."
      component: tools
      commandLine: mvn -Dwildfly.javaOpts="-Djboss.host.name=${NODE_NAME} -agentlib:jdwp=transport=dt_socket,address=*:5005,server=y,suspend=n" -Dmaven.test.skip=true clean package org.wildfly.plugins:wildfly-maven-plugin:dev
      workingDir: ${PROJECT_SOURCE}
      hotReloadCapable: true
      group:
        kind: debug
        isDefault: true
```
Sample devfile for JHipster Online
```yaml
schemaVersion: 2.2.2
metadata:
  name: jhipster-online
  version: 2.33.1
  description: "Stack with JHipster Online on Red Hat OpenShift Dev Spaces. 
    This stack include:
    - JHipster 8.8.0. for generate Spring Boot 3.4.1 projects.
    - generator-jhipster-micronaut 3.6.0 for generate Micronaut 4.7.2 projects.
    - generator-jhipster-quarkus 3.4.0 for generate Quarkus 3.11.1 projects.
    - generator-jhipster-dotnetcore 4.2.0 for generate .Net 8.0 projects.
    Watch the demo video:
    - https://youtu.be/b7xbcTAGNIQ?si=snE57Th4S3gPv_Vn"    
  displayName: JHipster Online
  icon: https://raw.githubusercontent.com/redhat-developer-demos/jhipster-online/main/jhipster-icon.png
  website: https://start.jhipster.tech
  tags:
    - Java
    - JHipster
    - Angular
    - Spring
    - Quarkus
    - Micronaut
  language: Java
  projectType: springboot
projects:
  - name: jhipster-online
    git:
      remotes:
        origin: 'https://github.com/redhat-developer-demos/jhipster-online'
      checkoutFrom:
        revision: main
components:
  - name: tools
    container:
      image: 'quay.io/devfile/jhipster-online@sha256:1f284df66c8ef209ea2cd1a10516e9ba424508a11341eead650e88027858d3ee'
      mountSources: true
      cpuLimit: '4'
      cpuRequest: '1'
      memoryLimit: '8G'
      memoryRequest: '4G'
      volumeMounts:
        - name: m2
          path: /home/user/.m2
        - name: config
          path: /home/user/.config
        - name: npm
          path: /home/user/.npm
      endpoints:
        - exposure: public
          name: backend
          protocol: https
          targetPort: 8080
        - exposure: public
          name: debug
          targetPort: 4200
        - exposure: public
          name: frontend
          protocol: https
          targetPort: 9000
        - exposure: public
          name: debug-frontend
          protocol: https
          targetPort: 9001
        - exposure: public
          name: browser-sync
          protocol: https
          targetPort: 3001
      env:
        - value: '-XX:MaxRAMPercentage=50.0 -XX:+UseParallelGC -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xms20m -Djava.security.egd=file:/dev/./urandom -Duser.home=/home/jboss'
          name: JAVA_OPTS
        - value: $(JAVA_OPTS)
          name: MAVEN_OPTS
        - value: '/home/tooling/.sdkman/candidates/java/11.0.15-tem'
          name: JAVA_HOME
  - name: m2
    volume:
      size: 512Mi
  - name: config
    volume:
      size: 512Mi
  - name: npm
    volume:
      size: 512Mi
commands:
  - id: kubectl-add-mysql
    exec:
      label: 'Kubernetes apply MariaDB Instance (Kubernetes cluster)'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'kubectl apply -f src/main/kubernetes/mysql.yaml'
  - id: oc-add-mysql
    exec:
      label: 'OpenShift apply MariaDB Instance (OpenShift cluster)'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'oc apply -f src/main/kubernetes/mysql.yaml'
  - id: oc-remove-mysql
    exec:
      label: 'OpenShift remove MariaDB Instance (OpenShift cluster)'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'oc delete all --selector app=mariadb'
  - id: yarn-install
    exec:
      label: 'Package the application'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'yarn install'
      group:
        kind: build
        isDefault: true
  - id: start-frontend
    exec:
      label: 'Start Frontend'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'yarn start'
      group:
        kind: run
        isDefault: true
  - id: start-backend
    exec:
      label: 'Start JHipster Online'
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: 'chmod 777 ./mvnw && ./mvnw'
      group:
        kind: run
        isDefault: false
```
Sample devfile for Angular
```yaml
schemaVersion: 2.2.2
metadata:
  name: nodejs-angular
  displayName: Angular
  description: "Angular is a development platform, built on TypeScript. As a platform, Angular includes:
    A component-based framework for building scalable web applications
    A collection of well-integrated libraries that cover a wide variety of features, including routing, forms management, client-server communication, and more
    A suite of developer tools to help you develop, build, test, and update your code"
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/angular.svg
  tags:
    - Node.js
    - Angular
  projectType: Angular
  language: TypeScript
  provider: Red Hat
  version: 2.2.1
starterProjects:
  - name: nodejs-angular-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-nodejs-angular.git
components:
  - container:
      endpoints:
        - name: https-angular
          protocol: https
          targetPort: 4200
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      args: ["tail", "-f", "/dev/null"]
      memoryLimit: 1024Mi
    name: runtime
commands:
  - id: install
    exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
  - id: run
    exec:
      commandLine: npm run start
      component: runtime
      group:
        isDefault: true
        kind: run
      hotReloadCapable: true
      workingDir: ${PROJECT_SOURCE}
```
Sample devfile for Node.js MongoDB
```yaml
schemaVersion: 2.2.2
metadata:
  name: nodejs-mongodb
  displayName: Node.js MongoDB
  description: NodeJS web application which communicates with MongoDB
  icon: https://github.com/che-samples/nodejs-mongodb-sample/raw/main/nodejs-mongodb.png
  tags:
    - Node.js
    - MongoDB
    - ubi9
  projectType: universal
  language: Polyglot
  version: 1.0.0
starterProjects:
  - name: nodejs-mongodb-sample
    git:
      remotes:
        origin: 'https://github.com/che-samples/nodejs-mongodb-sample'
      checkoutFrom:
        revision: main
components:
  - name: tools
    container:
      # quay.io/devfile/universal-developer-image:ubi9-dd1f49f
      image: quay.io/devfile/universal-developer-image@sha256:c7ef40c8e6997d8961572a0e9088aec6735b4df0dedae2361085a44260b8c12f
      env:
      # The values below are used to set up the environment for running the application
        - name: SECRET
          value: dummy-value 
        - name: NODE_ENV
          value: production
      endpoints:
        - exposure: public
          name: nodejs
          targetPort: 8080
          protocol: https
      memoryLimit: 1G
      mountSources: true

  - name: mongo
    container:
      # bitnami/mongodb:8.0.8
      image: bitnami/mongodb@sha256:b3bd5b6be9a0734dfa027c866ba17c42fd4c4325c973669e5e77a354c30e84a3
      env:
        - name: MONGODB_USERNAME
          value: user
        - name: MONGODB_PASSWORD
          value: password
        - name: MONGODB_DATABASE
          value: guestbook
        - name: MONGODB_ROOT_PASSWORD
          value: password
      endpoints:
        - name: mongodb
          exposure: internal
          targetPort: 27017
          attributes:
            discoverable: 'true'
      memoryLimit: 512Mi
      mountSources: true
      volumeMounts:
        - name: mongo-storage
          path: /bitnami/mongodb

  - name: mongo-storage
    volume:
      size: 256Mi

commands:
  - id: run-application
    exec:
      label: "Run the application"
      component: tools
      workingDir: ${PROJECT_SOURCE}
      commandLine: "npm install && node --inspect=9229 app.js"
      group:
        kind: run
```
Sample devfile for Next.js
```yaml
schemaVersion: 2.2.2
metadata:
  name: nodejs-nextjs
  displayName: Next.js
  description: "Next.js gives you the best developer experience with all the features you need for production:
    hybrid static & server rendering, TypeScript support, smart bundling, route pre-fetching, and more.
    No config needed."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/next-js.svg
  tags:
    - Node.js
    - Next.js
  projectType: Next.js
  language: TypeScript
  provider: Red Hat
  version: 1.2.1
starterProjects:
  - name: nodejs-nextjs-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-nodejs-nextjs.git
components:
  - container:
      endpoints:
        - name: https-nextjs
          protocol: https
          targetPort: 3000
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      command: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
    name: runtime
commands:
  - exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: npm run dev
      component: runtime
      group:
        isDefault: true
        kind: run
      hotReloadCapable: true
      workingDir: ${PROJECT_SOURCE}
    id: run
```
Sample devfile for Nuxt.js
```yaml
schemaVersion: 2.2.2
metadata:
  name: nodejs-nuxtjs
  displayName: Nuxt.js
  description: "Nuxt.js is the backbone of your Vue.js project, giving structure to build your project with confidence while keeping flexibility.
    Its goal is to help Vue developers take advantage of top-notch technologies, fast, easy and in an organized way."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/nuxt-js.svg
  tags:
    - Node.js
    - Nuxt.js
  projectType: Nuxt.js
  language: TypeScript
  provider: Red Hat
  version: 1.2.1
starterProjects:
  - name: nodejs-nuxtjs-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-nodejs-nuxtjs.git
components:
  - container:
      endpoints:
        - name: https-nuxtjs
          protocol: https
          targetPort: 3000
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
    name: runtime
commands:
  - exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: npm run dev
      component: runtime
      group:
        isDefault: true
        kind: run
      hotReloadCapable: true
      workingDir: ${PROJECT_SOURCE}
    id: run
```
Sample devfile for React
```yaml
schemaVersion: 2.3.0
metadata:
  name: nodejs-react
  displayName: React
  description: "React is a free and open-source front-end JavaScript library for building user interfaces based on UI components.
    It is maintained by Meta and a community of individual developers and companies."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/react.svg
  tags:
    - Node.js
    - React
  projectType: React
  language: TypeScript
  provider: Red Hat
  version: 2.2.1
starterProjects:
  - name: nodejs-react-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stacks-nodejs-react.git
components:
  - container:
      endpoints:
        - name: https-react
          targetPort: 3000
          protocol: https
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
    name: runtime
commands:
  - exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: npm run dev
      component: runtime
      group:
        isDefault: true
        kind: run
      workingDir: ${PROJECT_SOURCE}
    id: run
```
Sample devfile for Svelte
```yaml
schemaVersion: 2.3.0
metadata:
  name: nodejs-svelte
  displayName: Svelte
  description: "Svelte is a radical new approach to building user interfaces.
    Whereas traditional frameworks like React and Vue do the bulk of their work in the browser, Svelte shifts that work into a compile step that happens when you build your app."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/svelte.svg
  tags:
    - Node.js
    - Svelte
  projectType: Svelte
  language: TypeScript
  provider: Red Hat
  version: 1.2.1
starterProjects:
  - name: nodejs-svelte-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-nodejs-svelte.git
components:
  - container:
      endpoints:
        - name: https-svelte
          targetPort: 3000
          protocol: https
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
    name: runtime
commands:
  - exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: npm run dev
      component: runtime
      group:
        isDefault: true
        kind: run
      workingDir: ${PROJECT_SOURCE}
    id: run
```
Sample devfile for Vue
```yaml
schemaVersion: 2.3.0
metadata:
  name: nodejs-vue
  displayName: Vue
  description: "Vue 3 is a JavaScript framework for building user interfaces.
    It builds on top of standard HTML, CSS and JavaScript, and provides a declarative and component-based programming model that helps you efficiently develop user interfaces, be it simple or complex"
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/vue.svg
  tags:
    - Node.js
    - Vue
  projectType: Vue
  language: TypeScript
  provider: Red Hat
  version: 1.2.1
starterProjects:
  - name: nodejs-vue-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-nodejs-vue.git
components:
  - container:
      env:
        - name: CYPRESS_CACHE_FOLDER
          value: ${PROJECT_SOURCE}
      endpoints:
        - name: https-vue
          targetPort: 3000
          protocol: https
      image: registry.access.redhat.com/ubi8/nodejs-18:1-137.1742991061
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
    name: runtime
commands:
  - exec:
      commandLine: npm install
      component: runtime
      group:
        isDefault: true
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: npm run dev
      component: runtime
      group:
        isDefault: true
        kind: run
      hotReloadCapable: true
      workingDir: ${PROJECT_SOURCE}
    id: build
```
Sample devfile for Node.js Runtime
```yaml
schemaVersion: 2.2.2
metadata:
  name: nodejs
  displayName: Node.js Runtime
  description: Node.js 18 application
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/node-js.svg
  tags:
    - Node.js
    - Express
    - ubi8
  projectType: Node.js
  language: JavaScript
  version: 2.2.1
starterProjects:
  - name: nodejs-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: 'https://github.com/nodeshift-starters/devfile-sample.git'
components:
  - name: runtime
    container:
      image: registry.access.redhat.com/ubi8/nodejs-18:1-32
      args: ['tail', '-f', '/dev/null']
      memoryLimit: 1024Mi
      mountSources: true
      env:
        - name: DEBUG_PORT
          value: '5858'
      endpoints:
        - name: https-node
          targetPort: 3000
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
commands:
  - id: install
    exec:
      component: runtime
      commandLine: npm install
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: true
  - id: run
    exec:
      component: runtime
      commandLine: npm start
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: run
        isDefault: true
  - id: debug
    exec:
      component: runtime
      commandLine: npm run debug
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: debug
        isDefault: true
  - id: test
    exec:
      component: runtime
      commandLine: npm test
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: test
        isDefault: true
```
Sample devfile for Ollama
```yaml
schemaVersion: 2.2.2
metadata:
  name: ollama
  displayName: Ollama
  description: Get up and running with large language models with Ollama, Continue, Llama3, and StarCoder2
  icon: https://ollama.com/public/ollama.png
  tags:
    - Ollama
    - Continue
    - Llama3
    - Starcoder2
  projectType: universal
  language: Polyglot
  version: 1.0.0
projects:
  - name: cde-ollama-continue
    git:
      remotes:
        origin: 'https://github.com/redhat-developer-demos/cde-ollama-continue'
      checkoutFrom:
        revision: main
components:
- name: udi
  container:
    image: quay.io/devfile/universal-developer-image:ubi8-98224a3
    memoryLimit: 4Gi
    memoryRequest: 2Gi
    cpuLimit: 4000m
    cpuRequest: 1000m
    mountSources: true
    sourceMapping: /projects
- name: ollama
  attributes:
    container-overrides:
      resources:
        limits:
          cpu: 4000m
          memory: 12Gi
          # nvidia.com/gpu: 1 # Uncomment this if the pod shall be scheduled only on a GPU node
        requests:
          cpu: 1000m
          memory: 8Gi
          # nvidia.com/gpu: 1 # Uncomment this if the pod shall be scheduled only on a GPU node
  container:
    image: docker.io/ollama/ollama:0.5.4
    mountSources: true
    sourceMapping: /.ollama
commands:
  - id: pullmodel
    exec:
      component: ollama
      commandLine: "ollama pull llama3:8b"
  - id: pullautocompletemodel
    exec:
      component: ollama
      commandLine: "ollama pull starcoder2:3b"
  - id: copyconfig
    exec:
      component: udi
      commandLine: "mkdir /home/user/.continue && cp /projects/cde-ollama-continue/continue-config.json /home/user/.continue/config.json"
events:
  postStart:
    - pullmodel
    - pullautocompletemodel
    - copyconfig
```
Sample devfile for Laravel
```yaml
schemaVersion: 2.2.2
metadata:
  name: php-laravel
  displayName: Laravel
  description: "Laravel is an open-source PHP framework, which is robust and easy to understand.
    It follows a model-view-controller design pattern.
    Laravel reuses the existing components of different frameworks which helps in creating a web application.
    The web application thus designed is more structured and pragmatic."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/laravel.svg
  tags:
    - PHP
    - Composer
    - Laravel
  projectType: Laravel
  language: PHP
  provider: Red Hat
  version: 2.0.1
starterProjects:
  - name: php-laravel-starter
    git:
      checkoutFrom:
        revision: main
      remotes:
        origin: https://github.com/devfile-samples/devfile-stack-php-laravel.git
components:
  - container:
      endpoints:
        - name: https-laravel
          targetPort: 8000
          protocol: https
      image: quay.io/devfile/composer:2.5.8
      args: ["tail", "-f", "/dev/null"]
      memoryLimit: 1024Mi
      mountSources: true
    name: runtime
commands:
  - exec:
      commandLine: composer install
      component: runtime
      group:
        isDefault: false
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: install
  - exec:
      commandLine: cp .env.example .env
      component: runtime
      group:
        isDefault: false
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: cp-env
  - exec:
      commandLine: php artisan config:clear
      component: runtime
      group:
        isDefault: false
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: clear-config
  - exec:
      commandLine: php artisan key:generate
      component: runtime
      group:
        isDefault: false
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: gen-new-app-key
  - exec:
      commandLine: composer dump-autoload
      component: runtime
      group:
        isDefault: false
        kind: build
      workingDir: ${PROJECT_SOURCE}
    id: composer-dump
  - composite:
      commands:
        - install
        - cp-env
        - clear-config
        - gen-new-app-key
        - composer-dump
      group:
        isDefault: true
        kind: build
      label: Provision Laravel Server
      parallel: false
    id: init-server
  - exec:
      commandLine: php artisan serve --host=0.0.0.0
      component: runtime
      group:
        isDefault: true
        kind: run
      workingDir: ${PROJECT_SOURCE}
    id: run
```
Sample devfile for Django
```yaml
schemaVersion: 2.1.0
metadata:
  name: python-django
  displayName: Django
  description: "Django is a high-level Python web framework that enables rapid development of secure and maintainable websites.
    Built by experienced developers, Django takes care of much of the hassle of web development, so you can focus on writing your app without needing to reinvent the wheel.
    It is free and open source, has a thriving and active community, great documentation, and many options for free and paid-for support."
  icon: https://static.djangoproject.com/img/logos/django-logo-positive.svg
  tags:
    - Django
    - Python
    - Pip
  projectType: Django
  language: Python
  provider: Red Hat
  version: 2.1.0
starterProjects:
  - name: django-example
    git:
      remotes:
        origin: https://github.com/devfile-samples/python-django-ex
components:
  - name: py-web
    container:
      image: registry.access.redhat.com/ubi9/python-39:1-1743091356
      args: ["tail", "-f", "/dev/null"]
      mountSources: true
      endpoints:
        - name: http-django
          targetPort: 8000
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: pip-install-requirements
    exec:
      commandLine: pip install -r requirements.txt
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: true
      component: py-web
  - id: run-app
    exec:
      commandLine: 'python manage.py runserver 0.0.0.0:8000'
      workingDir: ${PROJECT_SOURCE}
      component: py-web
      group:
        kind: run
        isDefault: true
  - id: run-migrations
    exec:
      commandLine: 'python manage.py migrate'
      workingDir: ${PROJECT_SOURCE}
      component: py-web
  - id: debug
    exec:
      commandLine: 'pip install debugpy && export DEBUG_MODE=True && python -m debugpy --listen 0.0.0.0:${DEBUG_PORT} manage.py runserver 0.0.0.0:8000 --noreload --nothreading'
      workingDir: ${PROJECT_SOURCE}
      component: py-web
      group:
        kind: debug
```
Sample devfile for Python
```yaml
schemaVersion: 2.2.2
metadata:
  name: python
  displayName: Python
  description: "Python (version 3.9.x) is an interpreted, object-oriented, high-level programming language with dynamic semantics.
    Its high-level built in data structures, combined with dynamic typing and dynamic binding, make it very attractive for Rapid Application Development, as well as for use as a scripting or glue language to connect existing components together."
  icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/python.svg
  tags:
    - Python
    - Pip
    - Flask
  projectType: Python
  language: Python
  provider: Red Hat
  version: 2.2.0
starterProjects:
  - name: flask-example
    description:
      'Flask is a web framework, it’s a Python module that lets you develop web applications easily.
      It’s has a small and easy-to-extend core: it’s a microframework that doesn’t include an ORM (Object Relational Manager) or such features.'
    git:
      remotes:
        origin: https://github.com/devfile-samples/python-ex
components:
  - name: py
    container:
      image: registry.access.redhat.com/ubi9/python-39:1-1743091356
      args: ['tail', '-f', '/dev/null']
      mountSources: true
      endpoints:
        - name: https-python
          targetPort: 8080
          protocol: https
        - exposure: none
          name: debug
          targetPort: 5858
      env:
        - name: DEBUG_PORT
          value: '5858'
commands:
  - id: pip-install-requirements
    exec:
      commandLine: pip install -r requirements.txt
      workingDir: ${PROJECT_SOURCE}
      group:
        kind: build
        isDefault: true
      component: py
  - id: run-app
    exec:
      commandLine: 'python app.py'
      workingDir: ${PROJECT_SOURCE}
      component: py
      group:
        kind: run
        isDefault: true
  - id: debug-py
    exec:
      commandLine: 'pip install debugpy && python -m debugpy --listen 0.0.0.0:${DEBUG_PORT} app.py'
      workingDir: ${PROJECT_SOURCE}
      component: py
      group:
        kind: debug
```
Sample devfile for Universal Developer Image
```yaml
schemaVersion: 2.3.0
metadata:
  name: udi
  displayName: Universal Developer Image
  description: Universal Developer Image provides various programming languages tools and runtimes for instant coding
  icon: https://raw.githubusercontent.com/devfile/devfile-web/main/apps/landing-page/public/pwa-192x192.png
  tags:
    - Java
    - Maven
    - Scala
    - PHP
    - .NET
    - Node.js
    - Go
    - Python
    - Pip
    - ubi9
  projectType: universal
  language: Polyglot
  version: 1.0.0
components:
  - name: tools
    container:
      image: quay.io/devfile/universal-developer-image:ubi9-latest
      memoryLimit: 6G
      memoryRequest: 512Mi
      cpuRequest: 1000m
      cpuLimit: 4000m
      mountSources: true
```

