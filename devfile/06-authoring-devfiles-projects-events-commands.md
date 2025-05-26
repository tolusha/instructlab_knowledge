Adding projects
===============

This section describes how to add one or more projects to a devfile. Each starter project can contain either a `git` or `zip` object. See the following tables for project properties in a devfile:

#### starterProject object

| Key           | Type     | Required | Description                                                                 |
|---------------|----------|----------|-----------------------------------------------------------------------------|
| `name`        | string   | yes      | The name of your devfile.                                                  |
| `description` | string   | no       | The description of your starterProject.                                    |
| `clonePath`   | string   | no       | The path relative to the root of your projects. Clone your projects into this path. |

#### git object

| Key           | Type     | Required | Description                                  |
|---------------|----------|----------|----------------------------------------------|
| `checkoutFrom`| string   | no       | The location of your git repository.         |
| `remotes`     | string   | yes      | The branch that you use.                     |

#### zip object

| Key        | Type   | Required | Description                     |
|------------|--------|----------|---------------------------------|
| `location` | string | no       | The location of your zip.       |

  

Procedure
---------

1.  Add a `projects` section in the devfile, containing a list of one or more projects.
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: petclinic-dev-environment
          version: 1.0.0
        projects:
          - name: petclinic
            git:
              remotes:
                origin: 'https://github.com/spring-projects/spring-petclinic.git'
              checkoutFrom:
                revision: main
      ```
    
    #### A devfile with multiple projects
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: example-devfile
          version: 1.0.0
        projects:
          - name: frontend
            git:
              remotes:
                origin: 'https://github.com/acmecorp/frontend.git'
          - name: backend
            git:
              remotes:
                origin: 'https://github.com/acmecorp/backend.git'
      ```
    
2.  For each project, define an unique value for the mandatory `name` attribute.
    
3.  For each project, define a mandatory source of either the `git` or `zip` type.
    
    Projects with sources in Git. `checkoutFrom` refers to the branch being used.
    
    #### Project-source type: git
    
      ```yaml
        projects:
          - name: my-project1
            git:
              remotes:
                origin: 'https://github.com/my-org/project1.git'
              checkoutFrom:
                revision: main
      ```
    
    Projects with sources in a ZIP archive. `location` refers to the URL of a ZIP file.
    
    #### Project-source type: zip
    
      ```yaml
        source:
          zip:
            location: http://host.net/path/project-src.zip
      ```
    
4.  For each project, define the optional `clonePath` attribute to specify the path into which the project is to be cloned. The path must be relative to the `/projects/` directory, and it cannot leave the `/projects/` directory. The default value is the project name.
    
    #### Defining the clonePath attribute
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: my-project-dev
          version: 2.0.0
        projects:
          - name: my-project-resource
            clonePath: resources/my-project
            zip:
              location: http://host.net/path/project-res.zip
          - name: my-project2
              git:
                remotes:
                  origin: "https://github.com/my-org/project2.git"
                checkoutFrom:
                  revision: develop
      ```
    

Defining starter projects
=========================

Starter projects provide a starting point when bootstrapping new projects, for example, when using interactive tools like `odo init`. Users can select a base project from the list of starters in the devfile.

Each starter project requires a `name`, and a definition for either a `git` or `zip` object to set the location for the starter source code.

#### A devfile with git and zip starter projects

  ```yaml
    schemaVersion: 2.3.0
    starterProjects:
    - name: nodejs-starter
      git:
        remotes:
          origin: https://github.com/odo-devfiles/nodejs-ex.git
      
    - name: nodejs-zip-starter
      zip:
        location: https://github.com/odo-devfiles/nodejs-ex/archive/refs/tags/0.0.2.zip
  ```

#### A devfile with multiple git starter projects

  ```yaml
    schemaVersion: 2.3.0
    metadata:
      name: example-devfile
      version: 1.0.0
    starterProjects:
      - name: frontend
        git:
          remotes:
            origin: 'https://github.com/acmecorp/frontend.git'
      - name: backend
        git:
          remotes:
            origin: 'https://github.com/acmecorp/backend.git'
  ```

For a Git source in a starter project, a single remote must be specified. You can checkout from a specific branch name, tag or commit id. The default branch is used if the revision is not specified, or if the specified revision is not found.

With the optional `subDir` field, you can specify a subdirectory in the project to be used as root for the starter project. The path must be relative to the source location. The default value is `.` or the full source directory.

#### A starter project specifying revision and subDir
  ```yaml
    schemaVersion: 2.3.0
    starterProjects:
    - name: demo-starter
      git:
        remotes:
          origin: <git-repo>
          checkoutFrom:
            revision: 1.1.0Final        
        subDir: demo
  ```

A starter project may include a devfile within its contents. If so, the tool will use that devfile going forward. If no devfile is included, the tool will continue using the original devfile it used to fetch the starter project.


Adding commands
===============

You can use a devfile to specify commands to run in a workspace. Every command can contain a subset of actions. The actions in each subset are related to a specific component.


Procedure
---------

1.  Add a `commands` section to a devfile that contains a list of one or more commands.
    
2.  For each command, define a unique value for the mandatory `id` attribute.
    
3.  For each command, define a mandatory kind of one of the following kinds: `exec`, `apply` or `composite`
    
    #### sample command
    
    ```yaml
        commands:
          - id: build
            exec:
              component: mysql
              commandLine: mvn clean
              workingDir: /projects/spring-petclinic
    ```

Adding a command group
======================

Create command groups to help automate your devfile.

Procedure
---------

1.  Assign a given command to one or more groups that represent the nature of the command.
    
2.  Use the following supported group kinds: `build`, `run`, `test`, `debug` or `deploy`
    
3.  At most, there can only be one default command for each group kind. Set the default command by specifying `isDefault` to `true`.
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: mydevfile
        projects:
          - name: my-maven-project
            clonePath: maven/src/github.com/acme/my-maven-project
            git:
              remotes:
                origin: 'https://github.com/acme/my-maven-project.git'
        components:
          - name: maven
            container:
              image: eclipse/maven-jdk8:latest
              mountSources: true
              command: ['tail']
        commands:
          - id: package
            exec:
              component: maven
              commandLine: 'mvn package'
              group:
                kind: build
          - id: install
            exec:
              component: maven
              commandLine: 'mvn install'
              group:
                kind: build
                isDefault: true
      ```
    
4.  Use the `deploy` kind to reference a deploy command for an outerloop scenario.
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: python
          version: 1.0.0
          provider: Red Hat
          supportUrl: https://github.com/devfile-samples/devfile-support#support-information
          attributes:
            alpha.dockerimage-port: 8081
        parent:
          id: python
          registryUrl: 'https://registry.devfile.io'
        components:
          - name: outerloop-build
            image:
              imageName: python-image:latest
              dockerfile:
                uri: docker/Dockerfile
                buildContext: .
                rootRequired: false
          - name: outerloop-deploy
            kubernetes:
              uri: outerloop-deploy.yaml
        commands:
          - id: build-image
            apply:
              component: outerloop-build
          - id: deployk8s
            apply:
              component: outerloop-deploy
          - id: deploy
            composite:
              commands:
                - build-image
                - deployk8s
              group:
                kind: deploy
                isDefault: true
      ```

Adding an exec command
======================

Use the the `exec` command to automate the container actions.

1.  Define attributes for the `exec` command to run using the default shell in the container.
    
    *   A `commandLine` attribute that is a command to run.
        
    *   A `component` attribute that specifies the container in which to run the command. The `component` attribute value must correspond to an existing container component name.
        
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: mydevfile
        projects:
          - name: my-go-project
            clonePath: go/src/github.com/acme/my-go-project
            git:
              remotes:
                origin: 'https://github.com/acme/my-go-project.git'
        components:
          - name: go-cli
            container:
              image: golang
              memoryLimit: 512Mi
              mountSources: true
              command: ['sleep', 'infinity']
              env:
                - name: GOPATH
                  value: $(PROJECTS_ROOT)/go
                - name: GOCACHE
                  value: /tmp/go-cache
        commands:
          - id: compile and run
            exec:
              component: go-cli
              commandLine: 'go get -d && go run main.go'
              workingDir: '${PROJECTS_ROOT}/src/github.com/acme/my-go-project'
      ```
    
    Note!
    
    A command can have only one action, though you can use `composite` commands to run several commands either in sequence or in parallel.
    
Adding an apply command
=======================

Use the the `apply` command to apply a given component definition, usually a `kubernetes`, `openshift` or an `image` component. Apply commands are also typically bound to `preStart` and `postStop` events.

1.  Define the `apply` command to apply a given component. In the following example, two apply commands reference an `image` component and a `kubernetes` component to build a docker image and to apply the deployment YAML for an outerloop scenario.
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: python
          version: 1.0.0
          provider: Red Hat
          supportUrl: https://github.com/devfile-samples/devfile-support#support-information
          attributes:
            alpha.dockerimage-port: 8081
        parent:
          id: python
          registryUrl: 'https://registry.devfile.io'
        components:
          - name: outerloop-build
            image:
              imageName: python-image:latest
              dockerfile:
                uri: docker/Dockerfile
                buildContext: .
                rootRequired: false
          - name: outerloop-deploy
            kubernetes:
              uri: outerloop-deploy.yaml
        commands:
          - id: build-image
            apply:
              component: outerloop-build
          - id: deployk8s
            apply:
              component: outerloop-deploy
          - id: deploy
            composite:
              commands:
                - build-image
                - deployk8s
              group:
                kind: deploy
                isDefault: true
      ```

Adding a composite command
==========================

Connect multiple commands together by defining a composite command.

Procedure
---------

1.  Reference the individual commands that are called from a composite command by using the `id` of the command.
    
2.  Specify whether to run the commands within a composite command in sequence or parallel by defining the `parallel` property
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: mydevfile
        projects:
          - name: my-maven-project
            clonePath: maven/src/github.com/acme/my-maven-project
            git:
              remotes:
                origin: 'https://github.com/acme/my-maven-project.git'
        components:
          - name: maven
            container:
              image: eclipse/maven-jdk8:latest
              mountSources: true
              command: ['tail']
        commands:
          - id: package
            exec:
              component: maven
              commandLine: 'mvn package'
              group:
                kind: build
          - id: install
            exec:
              component: maven
              commandLine: 'mvn install'
              group:
                kind: build
                isDefault: true
          - id: installandpackage
            composite:
              commands:
                - install
                - package
              parallel: false
      ```

Adding event bindings
=====================

This section describes how to add an event to a v2.x devfile. An event can have three different type of objects:

1.  preStartObject
    
2.  postStartObject
    
3.  preStopObject
    

preStartObject
--------------

You can execute preStart events as init containers for the project pod in the order you specify the preStart events. The devfile `commandLine` and `workingDir` are the commands for the init container. As a result, the init container overwrites either the devfile or the container image `command` and `args`. If you use a composite command with `parallel: true`, the composite command executes as Kubernetes init containers.

postStartObject
---------------

When you create the Kubernetes deployment for the `odo` component, execute the postStart events.

preStopObject
-------------

Before you delete the Kubernetes deployment for the `odo` component, execute the preStop events.

See the following list for event properties in a devfile:

#### envObject

| Key   | Type   | Required | Description                          |
|-------|--------|----------|--------------------------------------|
| name  | string | yes      | The name of the environment variable. |
| value | string | yes      | The value of the environment variable. |


1.  Add an `events` section in the devfile, containing a list of `preStart` and `postStart` commands.

```yaml
    commands:
      - id: init-project
        apply:
          component: tools
      - id: copy-artifacts
        exec:
          component: tools
          commandLine: 'cp files'
          workingDir: $PROJECTS_ROOT
      - id: init-cache
        exec:
          component: tools
          commandLine: 'init cache'
          workingDir: /.m2
      - id: pre-compile-cmd
        composite:
          commands:
            - copy-artifacts
            - init-cache
    events:
      preStart:
        - init-project
      postStart:
        - pre-compile-cmd
```

Troubleshooting
===============

This section describes common problems during the devfile migration and potential solutions.

Workspace fails to start after the conversion
---------------------------------------------

Try referencing the [Universal Developer Image](https://quay.io/repository/devfile/universal-developer-image) as the only component in the devfile:
  ```yaml
    components:
      - name: tools
        container:
          image: quay.io/devfile/universal-developer-image:ubi8-latest
          memoryLimit: 3Gi
  ```

Note!

[Universal Developer Image](https://quay.io/repository/devfile/universal-developer-image) provides runtimes for various languages (including Java, Node.js, Python, PHP, Golang) and tools (including `curl`, `jq`, `git`) for development.

Conversion failures
-------------------

*   `Error processing devfile: failed to merge DevWorkspace volumes: duplicate volume found in devfile: volume_name`
    
    This means there are multiple volumes defined in the original devfile with the same name. Remove the duplicate volumes and proceed with the conversion.
    
*   `Error provisioning storage: Could not rewrite container volume mounts: volume component 'volume_name' is defined multiple times`
    
    This means the volume defined in the original devfile conflicts with a `volumeMount` propagated by an editor or a plug-in. Rename the volume in the devfile to be the same as the name of the `volumeMount` it conflicts with, and proceed with the conversion.
    
*   `Unable to resolve theia plugins: ms-vscode/node-debug2/latest is a mandatory plug-in but definition is not found on the plug-in registry. Aborting !`
    
    This means the deprecated `ms-vscode/node-debug2/latest` plug-in is included in the original devfile, but the newer plug-in registry includes the updated plug-in `ms-vscode/js-debug/latest`. Replace `ms-vscode/node-debug2/latest` with `ms-vscode/js-debug/latest` in the devfile to allow conversion to proceed.
