Adding components
=================

Each component in a single devfile must have a unique name and use one of the objects: `container`, `kubernetes`, `openshift`, `image` or `volume`.


Adding a kubernetes or openshift component
==========================================

You can add either a `kubernetes` or `openshift` component to a devfile.


Procedure
---------

1.  Define a component using the `kubernetes` or `openshift` property.
    
2.  Provide the content through the `uri` or `inlined` property.
    
    #### Adding an openshift component using the uri property    
    
      ```yaml
        components:
          - name: mysql
            openshift:
              uri: petclinic.yaml
      ```
    
    #### Adding a kubernetes component using the inlined property
    
      ```yaml
        components:
        - name: myk8deploy
          kubernetes:
            inlined:
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: pi
              spec:
                template:
                  spec:
                    containers:
                    - name: job
                      image: myimage
                      command: ["some",  "command"]
                    restartPolicy: Never
      ```
    
3.  Specify the endpoint through the endpoint property with `kubernetes` or `openshift` components.
    
4.  By default `kubernetes` or `openshift` components are not going to be deployed. Specify `deployByDefault: true` if you want to apply the component at start up.
    
5.  Associate `kubernetes` or `openshift` components with `apply` commands wth `deploy` command group kind. If the `kubernetes` or `openshift` component uses an image built by an `image` component defined in the devfile, you can create a composite `deploy` command to build the image and deploy the `kubernetes` or `openshift` component. For more information on `deploy` commands.
    

Adding a container component
============================

To incorporate custom tools into the workspace, define an image-based configuration of a container in a workspace using the `container` component type.


Procedure
---------

1.  Define a component using the type `container`.
    
    #### A container component
    
      ```yaml
        components:
          - name: maven
            container:
              image: eclipse/maven-jdk8:latest
              volumeMounts:
                - name: mavenrepo
                  path: /root/.m2
              env:
                - name: ENV_VAR
                  value: value
              endpoints:
                - name: maven-server
                  targetPort: 3101
                  protocol: https
                  secure: 'true'
                  exposure: public
              memoryRequest: 256M
              memoryLimit: 1536M
              cpuRequest: 0.1
              cpuLimit: 0.5
              command: ['tail']
              args: ['-f', '/dev/null']
      ```
    
    #### A minimal container component
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: mydevfile
        components:
          - name: go
            container:
              image: golang
              memoryLimit: 512Mi
              command: ['sleep', 'infinity']
      ```
    
    Specify the type of component using the `container` property. Use the `image` property to specify the image for the component. When defining the `image`, use container naming conventions. For example, the `image` property in the preceding example refers to the container image, `docker.io/library/golang:latest`.
    
    Use the `container` component to augment the image with additional resources and information. This component allows you to integrate the tooling provided by the image with the application that consumes the devfile.
    
2.  Mounting project sources
    
    For the `container` component to have access to the project sources, you must set the `mountSources` attribute to `true`.
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: mydevfile
        components:
          - name: go
            container:
              image: golang
              memoryLimit: 512Mi
              mountSources: true
              command: ['sleep', 'infinity']
      ```
    
    The sources are mounted on a location stored in the `PROJECTS_ROOT` environment variable that is made available in the running container of the image. This location defaults to `/projects`. If `sourceMapping` is defined in the container, it overrides the `PROJECT_ROOT` value and mounts the source to the path defined by `sourceMapping`.
    
3.  Specify a volume
    
    For the `container` component to have a shared volume, you must define a volume component in the devfile and reference the volume using `volumeMount` in container component. For more information on volume component, see [adding a volume component](/docs/2.3.0/adding-a-volume-component).
    
      ```yaml
        components:
          - name: mycontainer
            container:
              image: java11-maven:next
              memoryLimit: 768Mi
              mountSources: true
              volumeMounts:
                - name: m2
                  path: /home/user/.m2
          - name: m2
            volume:
              size: 1Gi
      ```
    
4.  Container Entrypoint
    
    Use the `command` attribute of the `container` type to modify the `entrypoint` command of the container created from the image. The availability of the `sleep` command and the support for the `infinity` argument depend on the base image used in the particular images.
    

Adding an image component
=========================

You can add an `image` component to a devfile.

Procedure
---------

1.  Define a component using the type `image`.
    
    Specify the location of the Dockerfile using the `uri` property. Specify arguments to be passed during the build with `args`. `buildContext` is the path of source directory to establish build context. If `rootRequired` is set to true, a privileged builder pod is required. The built container will be stored in the image provided by `imageName`.
    
    #### An image dockerfile component
    
      ```yaml
        components:
          - name: outerloop-build
            image:
              imageName: python-image:latest
              autoBuild: true
              dockerfile:
                uri: docker/Dockerfile
                args:
                  - 'MY_ENV=/home/path'
                buildContext: .
                rootRequired: false
      ```
    
    Alternatively, specify `git` and `devfileRegistry` as the image source.
    
    When specifying `git`, `fileLocation` refers to the location of the Dockerfile in the git repository. Specify the `remotes` for the git repository and a `checkoutFrom` to indicate which `revision` to check the source from.
    
    #### An image dockerfile component with git source
    
      ```yaml
        components:
          - name: outerloop-build
            image:
              imageName: python-image:latest
              dockerfile:
                git:
                  fileLocation: 'uri/Dockerfile'
                  checkoutFrom:
                    revision: 'main'
                    remote: 'origin'
                  remotes:
                    'origin': 'https://github.com/myorg/myrepo'
                buildContext: .
      ```
    
    When specifying `devfileRegistry`, `id` refers to the Id in a devfile registry that contains a Dockerfile. `registryUrl` refers to the Devfile Registry URL to pull the Dockerfile from
    
    #### An image dockerfile component with devfileRegistry source
    
      ```yaml
        components:
          - name: outerloop-build
            image:
              imageName: python-image:latest
              dockerfile:
                devfileRegistry:
                  id: python
                  registryUrl: myregistry.devfile.com
                buildContext: .
      ```


Adding a volume component
=========================

You can use a `volume` component to share files among container components and collaborate with other teams during the development process. Volumes mounted in a container require a volume component with the same name. Volume components can be shared across container components.

Procedure
---------

1.  Add a `volume` component and specify the size of it.
    
    #### Minimal volume example
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: mydevfile
        components:
          - name: mydevfile
            container:
              image: golang
              memoryLimit: 512Mi
              mountSources: true
              command: ['sleep', 'infinity']
              volumeMounts:
                - name: cache
                  path: /.cache
          - name: cache
            volume:
              size: 2Gi
      ```
    
2.  If you do not want your `volume` component to persist across restarts, specify it as ephemeral.
    
    #### Ephemeral volume example
    
      ```yaml
        schemaVersion: 2.2.0
        metadata:
          name: mydevfile
        components:
          - name: mydevfile
            volume:
              ephemeral: true
              size: 200G
      ```

Limiting resources usage
========================

This section describes how to limit resource use in devfiles.

Procedure
---------

1.  Specify container memory limit and memory request for components
    
    To specify a container memory limit for `container`, use the `memoryLimit` parameter and for the container memory request, use the `memoryRequest` parameter:
    
    #### Specify container memory limit and memory request for components
    
      ```yaml
        components:
          - name: maven
            container:
              image: eclipse/maven-jdk8:latest
              memoryLimit: 512M
              memoryRequest: 256M
      ```
    
2.  Specify container CPU limit and container CPU request for components
    
    To specify a container CPU limit for `container`, use the `cpuLimit` parameter and for the CPU request, use the `cpuRequest` parameter:
    
    #### Specify container CPU limit and CPU request for components
    
      ```yaml
        components:
          - name: maven
            container:
              image: eclipse/maven-jdk8:latest
              cpuLimit: 750m
              cpuRequest: 450m
      ```
    
3.  When not specified, the values may or may not be inferred from the application that consumes the devfile or from the underlying platform (for example, Kubernetes).

Defining environment variables
==============================

Environment variables are supported by the `container` component and the `exec` command. If the component has multiple containers, environment variables are provisioned for each container.

Procedure
---------

1.  Specify environment variables for `container` components
    
    #### Specifying environment variables for a container component
    
      ```yaml    
        schemaVersion: 2.2.0
        metadata:
          name: mydevfile
        components:
          - name: go
            container:
              image: golang
              memoryLimit: 512Mi
              mountSources: true
              command: ['sleep', 'infinity']
              env:
                - name: gopath
                  value: $(PROJECTS_ROOT)/go
      ```

Defining endpoints
==================

This section describes how to define endpoints and specify their properties.

Procedure
---------

1.  Specify endpoints properties as shown in the following example:

#### Specifying endpoint properties

```yaml
    schemaVersion: 2.2.0
    metadata:
      name: mydevfile
    projects:
      - name: my-go-project
        clonePath: go/src/github.com/acme/my-go-project
        git:
          remotes:
            origin: 'https://github.com/acme/my-go-project.git'
    components:
      - name: go
        container:
          image: golang
          memoryLimit: 512Mi
          mountSources: true
          command: ['sleep', 'infinity']
          env:
            - name: gopath
              value: $(PROJECTS_ROOT)/go
            - name: gocache
              value: /tmp/go-cache
          endpoints:
            - name: web
              targetPort: 8080
              exposure: public
      - name: postgres
        container:
          image: postgres
          memoryLimit: 512Mi
          env:
            - name: postgres_user
              value: user
            - name: postgres_password
              value: password
            - name: postgres_db
              value: database
          endpoints:
            - name: postgres
              targetPort: 5432
              exposure: none
```

This example has two containers that each define an endpoint. An endpoint has a name and a port that can be made accessible inside the workspace. The server running inside the container is listening on this port. See the following attributes that you can set on the endpoint:

*   `exposure`: When its value is `public`, the endpoint is accessible outside the workspace and is exposed on port `80` or `443` depending on whether TLS is enabled in devfiles. Access this endpoint from the devfile user interface.
    
*   `protocol`: For public endpoints, the protocol indicates to the devfile consumer how to construct the URL for the endpoint access. Typical values are `http`, `https`, `ws`, `wss`.
    
*   `secure`: Boolean. The default value is `false`. Setting this value to `true` puts the endpoint behind a JWT proxy. When the endpoint is secured this way, clients must supply a JWT workspace token to call this endpoint. The JWT proxy is deployed in the same Pod as the server and assumes the server listens only on the local loopback interface, such as `127.0.0.1`.
    
    Warning!
    
    Listening on any other interface than the local loopback poses a security risk. Such a server is accessible without the JWT authentication within the cluster network on the corresponding IP addresses.
    
*   `path`: The URL of the endpoint.
    

Specifying endpoints for `kubernetes` or `openshift` types
----------------------------------------------------------

```yaml
    schemaVersion: 2.2.0
    metadata:
      name: mydevfile
    components:
      - openshift:
          name: webapp
          uri: webapp.yaml
          endpoints:
            - name: 'web'
              targetPort: 8080
              exposure: public
      - openshift:
          name: mongo
          uri: mongo-db.yaml
          endpoints:
            - name: 'mongo-db'
              targetPort: 27017
              exposure: public
```
    

Defining kubernetes resources
=============================

This section explains how to reference Kubernetes or OpenShift resource lists in devfiles in order to describe complex deployments.

Procedure
---------

*   Because a devfile is internally represented as a single deployment, all resources from the Kubernetes or OpenShift list merge into that single deployment.
    
*   Avoid name conflicts when designing such lists.
    
*   When running devfiles on a Kubernetes cluster, only Kubernetes lists are supported. When running devfiles on an OpenShift cluster, both Kubernetes and OpenShift lists are supported.
    

The following component references a file that is relative to the location of the devfile:

```yaml
    schemaVersion: 2.2.0
    metadata:
      name: mydevfile
    projects:
      - name: my-go-project
        clonePath: go/src/github.com/acme/my-go-project
        git:
          remotes:
            origin: 'https://github.com/acme/my-go-project.git'
    components:
      - name: mycomponent
        kubernetes:
          uri: ../relative/path/postgres.yaml
```

The following is an example of the `postgres.yaml` file:

```yaml
    apiVersion: v1
    kind: List
    items:
      - apiVersion: v1
        kind: Deployment
        metadata:
          name: postgres
          labels:
            app: postgres
        spec:
          template:
            metadata:
              name: postgres
              app:
                name: postgres
            spec:
              containers:
                - image: postgres
                  name: postgres
                  ports:
                    - name: postgres
                      containerPort: 5432
                      volumeMounts:
                        - name: pg-storage
                          mountPath: /var/lib/postgresql/data
              volumes:
                - name: pg-storage
                  persistentVolumeClaim:
                    claimName: pg-storage
      - apiVersion: v1
        kind: Service
        metadata:
          name: postgres
          labels:
            app: postgres
            name: postgres
        spec:
          ports:
            - port: 5432
              targetPort: 5432
      - apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
          name: pg-storage
          labels:
            app: postgres
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 1Gi
```


