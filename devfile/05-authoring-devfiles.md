Overview
========

Creating a minimal devfile
--------------------------

The `schemaVersion` attribute is mandatory in a devfile.

### Procedure

*   Define the `schemaVersion` attribute in the devfile and specify a static name for the workspace with the `name` attribute.
    
    #### Minimal devfile with schema version and name
    
    ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: devfile-sample
          version: 0.0.1
    ```
        
Creating devfiles
=================

Most dev tools can utilize the devfile registry to fetch the stacks needed to begin development on projects. Sometimes, however, you might need to create a devfile from scratch or to create your own devfile template(s). This guide runs through the process, starting from a minimum devfile and building sample templates for common use cases.

Procedure
---------

1.  Creating a minimal devfile:
    
    *   `schemaVersion` is the only required root element
    *   `metadata` is optional but it is recommended to have in your templates
    
    #### Minimal Devfile
    
    ```yaml
        schemaVersion: 2.3.0
    ```
        
    
    #### Minimal Devfile with Metadata
    
    ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: devfile-sample
          version: 2.0.0
    ```
    
2.  Creating a web service template:
    
    1.  Template `metadata`
        
        *   Set the template `name` and `version`
        *   Set a `description` for the template
        *   Set the `projectType` and `language` to describe what kind of stack is being used
        *   Set `provider` to tell who is providing this template
        *   Set `tags` to give keyword which describe the elements of the stack
        *   Set `architectures` to specify the platforms support in the template
        *   For improved readability on devfile registries, set `displayName` to the title that will be the display text for this template and `icon` to tie a stack icon to the template:
          ```yaml
              schemaVersion: 2.3.0
              metadata:
                name: web-service
                version: 1.0.0
                description: A web service template.
                projectType: Go
                language: Go
                provider: Red Hat
                tags: [ 'Go', 'Gin', 'pq' ]
                architectures: [ 'amd64' ]
                displayName: Simple Web Service
                icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/golang.svg
          ```  
        
    2.  Setup `components`
        
        *   A `name` is required for a component
        *   If a `container` entity is defined, an `image` property must be specified
        *   Though `endpoints` is optional, it is needed to expose the port for web connections and requires:
            *   An endpoint `name`
            *   A `targetPort` to expose, for example, `8080` if that is your http port
        *   The web service might need to connect to an external database using environment variables. In this case, define environment variable names and values for the container component under `env`:
        ```yaml
            components:
              - name: web
                container:
                  endpoints:
                    - name: http
                      targetPort: 8080
                  env:
                    DATABASE_HOST: db.example.com
                    DATABASE_PORT: 5432
                    DATABASE_NAME: dev
                    DATABASE_USER: devuser
                    DATABASE_PASSWORD: devpassword
                  image: quay.io/devfile/golang:latest
        ```    
        
    3.  Adding `commands`
        
        *   An `id` to identify the command
        *   An `exec` entity must be defined with a `commandLine` string and a reference to a `component`
            *   _This implies that at least one component entity is defined under the root `components` element_
        *   The `workingDir` is set to where the project source is stored
        *   Command groups can be used to define automation that is useful for executing a web service:
          ```yaml
            commands:
              - id: build
                exec:
                  commandLine: go build main.go
                  component: web
                  workingDir: ${PROJECT_SOURCE}
                  group:
                    kind: build
                    isDefault: true
              - id: run
                exec:
                  commandLine: ./main
                  component: web
                  workingDir: ${PROJECT_SOURCE}
                  group:
                    kind: run
                    isDefault: true
          ```  
        
    4.  Define starter projects
        *   Add a starter project under `starterProjects` including at least a `name` and remote location, either `git` or `zip`
        *   It is recommended to include a starter project description:
            ```yaml
                starterProjects:
                  - name: web-starter
                    description: A web service starting point.
                    git:
                      remotes:
                        origin: https://github.com/devfile-samples/devfile-stack-go.git
            ```    
            
    5.  Completing the content, the complete devfile should look like the following:
    
    #### Complete Web Service Template
    
      ```yaml
        schemaVersion: 2.3.0
        metadata:
          name: web-service
          version: 1.0.0
          description: A web service template.
          projectType: Go
          language: Go
          provider: Red Hat
          tags: [ 'Go', 'Gin', 'pq' ]
          architectures: [ 'amd64' ]
          displayName: Simple Web Service
          icon: https://raw.githubusercontent.com/devfile-samples/devfile-stack-icons/main/golang.svg
        components:
          - name: web
            container:
              endpoints:
                - name: http
                  targetPort: 8080
              env:
                DATABASE_HOST: db.example.com
                DATABASE_PORT: 5432
                DATABASE_NAME: dev
                DATABASE_USER: devuser
                DATABASE_PASSWORD: devpassword
              image: quay.io/devfile/golang:latest
        commands:
          - id: build
            exec:
              commandLine: go build main.go
              component: web
              workingDir: ${PROJECT_SOURCE}
              group:
                kind: build
                isDefault: true
          - id: run
            exec:
              commandLine: ./main
              component: web
              workingDir: ${PROJECT_SOURCE}
              group:
                kind: run
                isDefault: true
        starterProjects:
          - name: web-starter
            description: A web service starting point.
            git:
              remotes:
                origin: https://github.com/devfile-samples/devfile-stack-go.git
      ```

Defining variables
==================

The `variables` object is a map of variable name-value pairs that you can use for string replacement in the devfile. Variables are referenced using the syntax `{{variable-name}}` to insert the corresponding value in string fields in the devfile.

You can define variables at the top level of the devfile or in the `parent` object. String replacement with variables cannot be used for:

*   `schemaVersion`, `metadata`, or `parent` source
*   Element identifiers such as `command.id`, `component.name`, `endpoint.name`, and `project.name`
*   References to identifiers, for example, when binding commands by name to events, when specifiying a command's component, or when specifying the volume mount name for a container
*   String enumerations such as command `group.kind` or `endpoint.exposure`

Procedure
---------

1.  Add a variable definition at the top level in your devfile:
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: java-maven
          version: 1.1.1
        variables:
          javaVersion: 11
      ```
    
2.  Reference the variable by name later in the devfile:
    
      ```yaml
        components:
        - name: tools
            container:
            image: quay.io/eclipse/che-java{{javaVersion}}-maven:nightly
      ```
    

If you reference a variable that is not defined, a non-blocking warning is issued.


Defining attributes
===================

As a developer, you can use devfile attributes to configure various features and properties according to the needs of users and tools. Attributes are implementation-dependent and written in free-form YAML.

Attributes can be defined at the top level of the devfile, or in the following objects:

*   `components`
*   `commands`
*   `projects`
*   `starterProjects`
*   `endpoints`
*   `metadata`: Attributes in metadata are deprecated. Use top-level attributes instead.

    

Procedure
---------

1.  Define attributes in a component:
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: java-quarkus
        ...
        components:
          - name: outerloop-deploy
            attributes:
              deployment/replicas: 1
              deployment/cpuLimit: "100m"
              deployment/cpuRequest: 10m
              deployment/memoryLimit: 250Mi
              deployment/memoryRequest: 100Mi
              deployment/container-port: 8081
            kubernetes:
              uri: outerloop-deploy.yaml
      ```
    
2.  Define a custom attribute at the devfile level.
    
    When no editor is specified, a default editor is provided. To represent this user-defined example, use the `editorFree` attribute as shown in the following example:
    
      ```yaml
        schemaVersion: 2.2.0
        attributes:
            editorFree: true
        metadata:
          name: petclinic-dev-environment
        components:
          - name: myapp
            kubernetes:
              uri: my-app.yaml
      ```
    

Packaging devfile
=================

Creating a devfile
------------------

To create a devfile, you can [start from scratch](/docs/2.3.0/create-devfiles) or use the [public community devfile registry](https://registry.devfile.io/viewer) to find predefined stacks for popular languages and frameworks. Once you have a devfile, save it as `.devfile.yaml` to your application’s root directory.

Resources to include with your devfile
--------------------------------------

If the devfile contains outerloop support, make sure the required files are included in your application with the correct path. Some common examples include:

*   The devfile contains an image component that uses a `Dockerfile`:
  ```yaml
    components:
      - name: outerloop-build
        image:
          imageName: image:latest
          dockerfile:
            uri: docker/Dockerfile
  ```

*   The devfile contains a deploy component:
  ```yaml
    components:
      - name: outerloop-deploy
        kubernetes:
          uri: kubernetes/deploy.yaml
  ```

If the devfile was created using the [public community devfile registry](https://registry.devfile.io/viewer), visit the [source directory on Github](https://github.com/devfile/registry/tree/main/stacks) to get the required files.



    
    
