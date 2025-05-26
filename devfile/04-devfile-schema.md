# Description

Devfile describes the structure of a cloud-native devworkspace and development environment.

# Type

object

# Title

Devfile schema - Version 2.3.0

# Required

- schemaVersion

# Properties

## Attributes

### Description

Map of implementation-dependant free-form YAML attributes.

### Type

object

### Additional Properties

true

## Commands

### Description

Predefined, ready-to-use, devworkspace-related commands

### Type

array

### Items

#### Type

object

#### Required

- id

#### One of

| Required |
| --- |
| exec |
| apply |
| composite |

#### Properties

##### Apply

###### Description

Command that consists in applying a given component definition, typically bound to a devworkspace event.

For example, when an `apply` command is bound to a `preStart` event, and references a `container` component, it will start the container as a K8S initContainer in the devworkspace POD, unless the component has its `dedicatedPod` field set to `true`.

When no `apply` command exist for a given component, it is assumed the component will be applied at devworkspace start by default, unless `deployByDefault` for that component is set to false.

###### Type

object

###### Required

- component

###### Properties

###### Component

###### Description

Describes component that will be applied

###### Type

string

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Required

- kind

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Additional Properties

false

##### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

##### Composite

###### Description

Composite command that allows executing several sub-commands either sequentially or concurrently

###### Type

object

###### Properties

###### Commands

###### Description

The commands that comprise this composite command

###### Type

array

###### Items

###### Type

string

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Required

- kind

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Parallel

###### Description

Indicates if the sub-commands should be executed concurrently

###### Type

boolean

###### Additional Properties

false

##### Exec

###### Description

CLI Command executed in an existing component container

###### Type

object

###### Required

- commandLine
- component

###### Properties

###### Command Line

###### Description

The actual command-line string

Special variables that can be used:

- `$PROJECTS_ROOT`: A path where projects sources are mounted as defined by container component's sourceMapping.

- `$PROJECT_SOURCE`: A path to a project source ($PROJECTS_ROOT/<project-name>). If there are multiple projects, this will point to the directory of the first one.

###### Type

string

###### Component

###### Description

Describes component to which given action relates

###### Type

string

###### Env

###### Description

Optional list of environment variables that have to be set before running the command

###### Type

array

###### Items

###### Type

object

###### Required

- name
- value

###### Properties

###### Name

###### Type

string

###### Value

###### Type

string

###### Additional Properties

false

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Required

- kind

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Hot Reload Capable

###### Description

Specify whether the command is restarted or not when the source code changes. If set to `true` the command won't be restarted. A *hotReloadCapable* `run` or `debug` command is expected to handle file changes on its own and won't be restarted. A *hotReloadCapable* `build` command is expected to be executed only once and won't be executed again. This field is taken into account only for commands `build`, `run` and `debug` with `isDefault` set to `true`.

Default value is `false`

###### Type

boolean

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Working Dir

###### Description

Working directory where the command should be executed

Special variables that can be used:

- `$PROJECTS_ROOT`: A path where projects sources are mounted as defined by container component's sourceMapping.

- `$PROJECT_SOURCE`: A path to a project source ($PROJECTS_ROOT/<project-name>). If there are multiple projects, this will point to the directory of the first one.

###### Type

string

###### Additional Properties

false

##### ID

###### Description

Mandatory identifier that allows referencing this command in composite commands, from a parent, or in events.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

#### Additional Properties

false

## Components

### Description

List of the devworkspace components, such as editor and plugins, user-provided containers, or other types of components

### Type

array

### Items

#### Type

object

#### Required

- name

#### One of

| Required |
| --- |
| container |
| kubernetes |
| openshift |
| volume |
| image |

#### Properties

##### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

##### Container

###### Description

Allows adding and configuring devworkspace-related containers

###### Type

object

###### Required

- image

###### Properties

###### Annotation

###### Description

Annotations that should be added to specific resources for this container

###### Type

object

###### Properties

###### Deployment

###### Description

Annotations to be added to deployment

###### Type

object

###### Additional Properties

###### Type

string

###### Service

###### Description

Annotations to be added to service

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Args

###### Description

The arguments to supply to the command running the dockerimage component. The arguments are supplied either to the default command provided in the image or to the overridden command.

Defaults to an empty array, meaning use whatever is defined in the image.

###### Type

array

###### Items

###### Type

string

###### Command

###### Description

The command to run in the dockerimage component instead of the default one provided in the image.

Defaults to an empty array, meaning use whatever is defined in the image.

###### Type

array

###### Items

###### Type

string

###### Cpu Limit

###### Type

string

###### Cpu Request

###### Type

string

###### Dedicated Pod

###### Description

Specify if a container should run in its own separated pod, instead of running as part of the main development environment pod.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name
- targetPort

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Default

public

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Default

http

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Env

###### Description

Environment variables used in this container.

The following variables are reserved and cannot be overridden via env:

- `$PROJECTS_ROOT`

- `$PROJECT_SOURCE`

###### Type

array

###### Items

###### Type

object

###### Required

- name
- value

###### Properties

###### Name

###### Type

string

###### Value

###### Type

string

###### Additional Properties

false

###### Image

###### Type

string

###### Memory Limit

###### Type

string

###### Memory Request

###### Type

string

###### Mount Sources

###### Description

Toggles whether or not the project source code should be mounted in the component.

Defaults to true for all component types except plugins and components that set `dedicatedPod` to true.

###### Type

boolean

###### Source Mapping

###### Description

Optional specification of the path in the container where project sources should be transferred/mounted when `mountSources` is `true`. When omitted, the default value of /projects is used.

###### Type

string

###### Default

/projects

###### Volume Mounts

###### Description

List of volumes mounts that should be mounted is this container.

###### Type

array

###### Items

###### Description

Volume that should be mounted to a component container

###### Type

object

###### Required

- name

###### Properties

###### Name

###### Description

The volume mount name is the name of an existing `Volume` component. If several containers mount the same volume name then they will reuse the same volume and will be able to access to the same files.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

The path in the component container where the volume should be mounted. If not path is mentioned, default path is the is `/<name>`.

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

##### Image

###### Description

Allows specifying the definition of an image for outer loop builds

###### Type

object

###### Required

- imageName

###### One of

| Required |
| --- |
| dockerfile |

###### Properties

###### Auto Build

###### Description

Defines if the image should be built during startup.

Default value is `false`

###### Type

boolean

###### Dockerfile

###### Description

Allows specifying dockerfile type build

###### Type

object

###### One of

| Required |
| --- |
| uri |
| devfileRegistry |
| git |

###### Properties

###### Args

###### Description

The arguments to supply to the dockerfile build.

###### Type

array

###### Items

###### Type

string

###### Build Context

###### Description

Path of source directory to establish build context. Defaults to ${PROJECT_SOURCE} in the container

###### Type

string

###### Devfile Registry

###### Description

Dockerfile's Devfile Registry source

###### Type

object

###### Required

- id

###### Properties

###### ID

###### Description

Id in a devfile registry that contains a Dockerfile. The src in the OCI registry required for the Dockerfile build will be downloaded for building the image.

###### Type

string

###### Registry Url

###### Description

Devfile Registry URL to pull the Dockerfile from when using the Devfile Registry as Dockerfile src. To ensure the Dockerfile gets resolved consistently in different environments, it is recommended to always specify the `devfileRegistryUrl` when `Id` is used.

###### Type

string

###### Additional Properties

false

###### Git

###### Description

Dockerfile's Git source

###### Type

object

###### Required

- remotes

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### File Location

###### Description

Location of the Dockerfile in the Git repository when using git as Dockerfile src. Defaults to Dockerfile.

###### Type

string

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Root Required

###### Description

Specify if a privileged builder pod is required.

Default value is `false`

###### Type

boolean

###### Uri

###### Description

URI Reference of a Dockerfile. It can be a full URL or a relative URI from the current devfile as the base URI.

###### Type

string

###### Additional Properties

false

###### Image Name

###### Description

Name of the image for the resulting outerloop build

###### Type

string

###### Additional Properties

false

##### Kubernetes

###### Description

Allows importing into the devworkspace the Kubernetes resources defined in a given manifest. For example this allows reusing the Kubernetes definitions used to deploy some runtime components in production.

###### Type

object

###### One of

| Required |
| --- |
| uri |
| inlined |

###### Properties

###### Deploy by Default

###### Description

Defines if the component should be deployed during startup.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name
- targetPort

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Default

public

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Default

http

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Inlined

###### Description

Inlined manifest

###### Type

string

###### Uri

###### Description

Location in a file fetched from a uri.

###### Type

string

###### Additional Properties

false

##### Name

###### Description

Mandatory name that allows referencing the component from other elements (such as commands) or from an external devfile that may reference this component through a parent or a plugin.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

##### Openshift

###### Description

Allows importing into the devworkspace the OpenShift resources defined in a given manifest. For example this allows reusing the OpenShift definitions used to deploy some runtime components in production.

###### Type

object

###### One of

| Required |
| --- |
| uri |
| inlined |

###### Properties

###### Deploy by Default

###### Description

Defines if the component should be deployed during startup.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name
- targetPort

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Default

public

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Default

http

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Inlined

###### Description

Inlined manifest

###### Type

string

###### Uri

###### Description

Location in a file fetched from a uri.

###### Type

string

###### Additional Properties

false

##### Volume

###### Description

Allows specifying the definition of a volume shared by several other components

###### Type

object

###### Properties

###### Ephemeral

###### Description

Ephemeral volumes are not stored persistently across restarts. Defaults to false

###### Type

boolean

###### Size

###### Description

Size of the volume

###### Type

string

###### Additional Properties

false

#### Additional Properties

false

## Dependent Projects

### Description

Additional projects related to the main project in the devfile, contianing names and sources locations

### Type

array

### Items

#### Type

object

#### Required

- name

#### One of

| Required |
| --- |
| git |
| zip |

#### Properties

##### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

##### Clone Path

###### Description

Path relative to the root of the projects to which this project should be cloned into. This is a unix-style relative path (i.e. uses forward slashes). The path is invalid if it is absolute or tries to escape the project root through the usage of '..'. If not specified, defaults to the project name.

###### Type

string

##### Git

###### Description

Project's Git source

###### Type

object

###### Required

- remotes

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

##### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

##### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

#### Additional Properties

false

## Events

### Description

Bindings of commands to events. Each command is referred-to by its name.

### Type

object

### Properties

#### Post Start

##### Description

IDs of commands that should be executed after the devworkspace is completely started. In the case of Che-Theia, these commands should be executed after all plugins and extensions have started, including project cloning. This means that those commands are not triggered until the user opens the IDE in his browser.

##### Type

array

##### Items

###### Type

string

#### Post Stop

##### Description

IDs of commands that should be executed after stopping the devworkspace.

##### Type

array

##### Items

###### Type

string

#### Pre Start

##### Description

IDs of commands that should be executed before the devworkspace start. Kubernetes-wise, these commands would typically be executed in init containers of the devworkspace POD.

##### Type

array

##### Items

###### Type

string

#### Pre Stop

##### Description

IDs of commands that should be executed before stopping the devworkspace.

##### Type

array

##### Items

###### Type

string

### Additional Properties

false

## Metadata

### Description

Optional metadata

### Type

object

### Properties

#### Architectures

##### Description

Optional list of processor architectures that the devfile supports, empty list suggests that the devfile can be used on any architecture

##### Type

array

##### Unique Items

true

##### Items

###### Description

Architecture describes the architecture type

###### Type

string

###### Enum

- amd64
- arm64
- ppc64le
- s390x

#### Attributes

##### Description

Map of implementation-dependant free-form YAML attributes. Deprecated, use the top-level attributes field instead.

##### Type

object

##### Additional Properties

true

#### Description

##### Description

Optional devfile description

##### Type

string

#### Display Name

##### Description

Optional devfile display name

##### Type

string

#### Global Memory Limit

##### Description

Optional devfile global memory limit

##### Type

string

#### Icon

##### Description

Optional devfile icon, can be a URI or a relative path in the project

##### Type

string

#### Language

##### Description

Optional devfile language

##### Type

string

#### Name

##### Description

Optional devfile name

##### Type

string

#### Project Type

##### Description

Optional devfile project type

##### Type

string

#### Provider

##### Description

Optional devfile provider information

##### Type

string

#### Support Url

##### Description

Optional link to a page that provides support information

##### Type

string

#### Tags

##### Description

Optional devfile tags

##### Type

array

##### Items

###### Type

string

#### Version

##### Description

Optional semver-compatible version

##### Type

string

##### Pattern

^([0-9]+)\.([0-9]+)\.([0-9]+)(\-[0-9a-z-]+(\.[0-9a-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$

#### Website

##### Description

Optional devfile website

##### Type

string

### Additional Properties

true

## Parent

### Description

Parent devworkspace template

### Type

object

### One of

| Required |
| --- |
| uri |
| id |
| kubernetes |

### Properties

#### Attributes

##### Description

Overrides of attributes encapsulated in a parent devfile. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

object

##### Additional Properties

true

#### Commands

##### Description

Overrides of commands encapsulated in a parent devfile or a plugin. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

array

##### Items

###### Type

object

###### Required

- id

###### One of

| Required |
| --- |
| exec |
| apply |
| composite |

###### Properties

###### Apply

###### Description

Command that consists in applying a given component definition, typically bound to a devworkspace event.

For example, when an `apply` command is bound to a `preStart` event, and references a `container` component, it will start the container as a K8S initContainer in the devworkspace POD, unless the component has its `dedicatedPod` field set to `true`.

When no `apply` command exist for a given component, it is assumed the component will be applied at devworkspace start by default, unless `deployByDefault` for that component is set to false.

###### Type

object

###### Properties

###### Component

###### Description

Describes component that will be applied

###### Type

string

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Additional Properties

false

###### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

###### Composite

###### Description

Composite command that allows executing several sub-commands either sequentially or concurrently

###### Type

object

###### Properties

###### Commands

###### Description

The commands that comprise this composite command

###### Type

array

###### Items

###### Type

string

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Parallel

###### Description

Indicates if the sub-commands should be executed concurrently

###### Type

boolean

###### Additional Properties

false

###### Exec

###### Description

CLI Command executed in an existing component container

###### Type

object

###### Properties

###### Command Line

###### Description

The actual command-line string

Special variables that can be used:

- `$PROJECTS_ROOT`: A path where projects sources are mounted as defined by container component's sourceMapping.

- `$PROJECT_SOURCE`: A path to a project source ($PROJECTS_ROOT/<project-name>). If there are multiple projects, this will point to the directory of the first one.

###### Type

string

###### Component

###### Description

Describes component to which given action relates

###### Type

string

###### Env

###### Description

Optional list of environment variables that have to be set before running the command

###### Type

array

###### Items

###### Type

object

###### Required

- name

###### Properties

###### Name

###### Type

string

###### Value

###### Type

string

###### Additional Properties

false

###### Group

###### Description

Defines the group this command is part of

###### Type

object

###### Properties

###### Is Default

###### Description

Identifies the default command for a given group kind

###### Type

boolean

###### Kind

###### Description

Kind of group the command is part of

###### Type

string

###### Enum

- build
- run
- test
- debug
- deploy

###### Additional Properties

false

###### Hot Reload Capable

###### Description

Specify whether the command is restarted or not when the source code changes. If set to `true` the command won't be restarted. A *hotReloadCapable* `run` or `debug` command is expected to handle file changes on its own and won't be restarted. A *hotReloadCapable* `build` command is expected to be executed only once and won't be executed again. This field is taken into account only for commands `build`, `run` and `debug` with `isDefault` set to `true`.

Default value is `false`

###### Type

boolean

###### Label

###### Description

Optional label that provides a label for this command to be used in Editor UI menus for example

###### Type

string

###### Working Dir

###### Description

Working directory where the command should be executed

Special variables that can be used:

- `$PROJECTS_ROOT`: A path where projects sources are mounted as defined by container component's sourceMapping.

- `$PROJECT_SOURCE`: A path to a project source ($PROJECTS_ROOT/<project-name>). If there are multiple projects, this will point to the directory of the first one.

###### Type

string

###### Additional Properties

false

###### ID

###### Description

Mandatory identifier that allows referencing this command in composite commands, from a parent, or in events.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Additional Properties

false

#### Components

##### Description

Overrides of components encapsulated in a parent devfile or a plugin. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

array

##### Items

###### Type

object

###### Required

- name

###### One of

| Required |
| --- |
| container |
| kubernetes |
| openshift |
| volume |
| image |

###### Properties

###### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

###### Container

###### Description

Allows adding and configuring devworkspace-related containers

###### Type

object

###### Properties

###### Annotation

###### Description

Annotations that should be added to specific resources for this container

###### Type

object

###### Properties

###### Deployment

###### Description

Annotations to be added to deployment

###### Type

object

###### Additional Properties

###### Type

string

###### Service

###### Description

Annotations to be added to service

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Args

###### Description

The arguments to supply to the command running the dockerimage component. The arguments are supplied either to the default command provided in the image or to the overridden command.

Defaults to an empty array, meaning use whatever is defined in the image.

###### Type

array

###### Items

###### Type

string

###### Command

###### Description

The command to run in the dockerimage component instead of the default one provided in the image.

Defaults to an empty array, meaning use whatever is defined in the image.

###### Type

array

###### Items

###### Type

string

###### Cpu Limit

###### Type

string

###### Cpu Request

###### Type

string

###### Dedicated Pod

###### Description

Specify if a container should run in its own separated pod, instead of running as part of the main development environment pod.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Env

###### Description

Environment variables used in this container.

The following variables are reserved and cannot be overridden via env:

- `$PROJECTS_ROOT`

- `$PROJECT_SOURCE`

###### Type

array

###### Items

###### Type

object

###### Required

- name

###### Properties

###### Name

###### Type

string

###### Value

###### Type

string

###### Additional Properties

false

###### Image

###### Type

string

###### Memory Limit

###### Type

string

###### Memory Request

###### Type

string

###### Mount Sources

###### Description

Toggles whether or not the project source code should be mounted in the component.

Defaults to true for all component types except plugins and components that set `dedicatedPod` to true.

###### Type

boolean

###### Source Mapping

###### Description

Optional specification of the path in the container where project sources should be transferred/mounted when `mountSources` is `true`. When omitted, the default value of /projects is used.

###### Type

string

###### Volume Mounts

###### Description

List of volumes mounts that should be mounted is this container.

###### Type

array

###### Items

###### Description

Volume that should be mounted to a component container

###### Type

object

###### Required

- name

###### Properties

###### Name

###### Description

The volume mount name is the name of an existing `Volume` component. If several containers mount the same volume name then they will reuse the same volume and will be able to access to the same files.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

The path in the component container where the volume should be mounted. If not path is mentioned, default path is the is `/<name>`.

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

###### Image

###### Description

Allows specifying the definition of an image for outer loop builds

###### Type

object

###### One of

| Required |
| --- |
| dockerfile |
| autoBuild |

###### Properties

###### Auto Build

###### Description

Defines if the image should be built during startup.

Default value is `false`

###### Type

boolean

###### Dockerfile

###### Description

Allows specifying dockerfile type build

###### Type

object

###### One of

| Required |
| --- |
| uri |
| devfileRegistry |
| git |

###### Properties

###### Args

###### Description

The arguments to supply to the dockerfile build.

###### Type

array

###### Items

###### Type

string

###### Build Context

###### Description

Path of source directory to establish build context. Defaults to ${PROJECT_SOURCE} in the container

###### Type

string

###### Devfile Registry

###### Description

Dockerfile's Devfile Registry source

###### Type

object

###### Properties

###### ID

###### Description

Id in a devfile registry that contains a Dockerfile. The src in the OCI registry required for the Dockerfile build will be downloaded for building the image.

###### Type

string

###### Registry Url

###### Description

Devfile Registry URL to pull the Dockerfile from when using the Devfile Registry as Dockerfile src. To ensure the Dockerfile gets resolved consistently in different environments, it is recommended to always specify the `devfileRegistryUrl` when `Id` is used.

###### Type

string

###### Additional Properties

false

###### Git

###### Description

Dockerfile's Git source

###### Type

object

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### File Location

###### Description

Location of the Dockerfile in the Git repository when using git as Dockerfile src. Defaults to Dockerfile.

###### Type

string

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Root Required

###### Description

Specify if a privileged builder pod is required.

Default value is `false`

###### Type

boolean

###### Uri

###### Description

URI Reference of a Dockerfile. It can be a full URL or a relative URI from the current devfile as the base URI.

###### Type

string

###### Additional Properties

false

###### Image Name

###### Description

Name of the image for the resulting outerloop build

###### Type

string

###### Additional Properties

false

###### Kubernetes

###### Description

Allows importing into the devworkspace the Kubernetes resources defined in a given manifest. For example this allows reusing the Kubernetes definitions used to deploy some runtime components in production.

###### Type

object

###### One of

| Required |
| --- |
| uri |
| inlined |

###### Properties

###### Deploy by Default

###### Description

Defines if the component should be deployed during startup.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Inlined

###### Description

Inlined manifest

###### Type

string

###### Uri

###### Description

Location in a file fetched from a uri.

###### Type

string

###### Additional Properties

false

###### Name

###### Description

Mandatory name that allows referencing the component from other elements (such as commands) or from an external devfile that may reference this component through a parent or a plugin.

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Openshift

###### Description

Allows importing into the devworkspace the OpenShift resources defined in a given manifest. For example this allows reusing the OpenShift definitions used to deploy some runtime components in production.

###### Type

object

###### One of

| Required |
| --- |
| uri |
| inlined |

###### Properties

###### Deploy by Default

###### Description

Defines if the component should be deployed during startup.

Default value is `false`

###### Type

boolean

###### Endpoints

###### Type

array

###### Items

###### Type

object

###### Required

- name

###### Properties

###### Annotation

###### Description

Annotations to be added to Kubernetes Ingress or Openshift Route

###### Type

object

###### Additional Properties

###### Type

string

###### Attributes

###### Description

Map of implementation-dependant string-based free-form attributes.

Examples of Che-specific attributes:
- cookiesAuthEnabled: "true" / "false",
- type: "terminal" / "ide" / "ide-dev",

###### Type

object

###### Additional Properties

true

###### Exposure

###### Description

Describes how the endpoint should be exposed on the network.
- `public` means that the endpoint will be exposed on the public network, typically through a K8S ingress or an OpenShift route.
- `internal` means that the endpoint will be exposed internally outside of the main devworkspace POD, typically by K8S services, to be consumed by other elements running on the same cloud internal network.
- `none` means that the endpoint will not be exposed and will only be accessible inside the main devworkspace POD, on a local address.

Default value is `public`

###### Type

string

###### Enum

- public
- internal
- none

###### Name

###### Type

string

###### Max Length

15

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Path

###### Description

Path of the endpoint URL

###### Type

string

###### Protocol

###### Description

Describes the application and transport protocols of the traffic that will go through this endpoint.
- `http`: Endpoint will have `http` traffic, typically on a TCP connection. It will be automaticaly promoted to `https` when the `secure` field is set to `true`.
- `https`: Endpoint will have `https` traffic, typically on a TCP connection.
- `ws`: Endpoint will have `ws` traffic, typically on a TCP connection. It will be automaticaly promoted to `wss` when the `secure` field is set to `true`.
- `wss`: Endpoint will have `wss` traffic, typically on a TCP connection.
- `tcp`: Endpoint will have traffic on a TCP connection, without specifying an application protocol.
- `udp`: Endpoint will have traffic on an UDP connection, without specifying an application protocol.

Default value is `http`

###### Type

string

###### Enum

- http
- https
- ws
- wss
- tcp
- udp

###### Secure

###### Description

Describes whether the endpoint should be secured and protected by some authentication process. This requires a protocol of `https` or `wss`.

###### Type

boolean

###### Target Port

###### Description

Port number to be used within the container component. The same port cannot be used by two different container components.

###### Type

integer

###### Additional Properties

false

###### Inlined

###### Description

Inlined manifest

###### Type

string

###### Uri

###### Description

Location in a file fetched from a uri.

###### Type

string

###### Additional Properties

false

###### Volume

###### Description

Allows specifying the definition of a volume shared by several other components

###### Type

object

###### Properties

###### Ephemeral

###### Description

Ephemeral volumes are not stored persistently across restarts. Defaults to false

###### Type

boolean

###### Size

###### Description

Size of the volume

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

#### Dependent Projects

##### Description

Overrides of dependentProjects encapsulated in a parent devfile. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

array

##### Items

###### Type

object

###### Required

- name

###### One of

| Required |
| --- |
| git |
| zip |

###### Properties

###### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

###### Clone Path

###### Description

Path relative to the root of the projects to which this project should be cloned into. This is a unix-style relative path (i.e. uses forward slashes). The path is invalid if it is absolute or tries to escape the project root through the usage of '..'. If not specified, defaults to the project name.

###### Type

string

###### Git

###### Description

Project's Git source

###### Type

object

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

#### ID

##### Description

Id in a registry that contains a Devfile yaml file

##### Type

string

#### Kubernetes

##### Description

Reference to a Kubernetes CRD of type DevWorkspaceTemplate

##### Type

object

##### Required

- name

##### Properties

###### Name

###### Type

string

###### Namespace

###### Type

string

##### Additional Properties

false

#### Projects

##### Description

Overrides of projects encapsulated in a parent devfile. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

array

##### Items

###### Type

object

###### Required

- name

###### One of

| Required |
| --- |
| git |
| zip |

###### Properties

###### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

###### Clone Path

###### Description

Path relative to the root of the projects to which this project should be cloned into. This is a unix-style relative path (i.e. uses forward slashes). The path is invalid if it is absolute or tries to escape the project root through the usage of '..'. If not specified, defaults to the project name.

###### Type

string

###### Git

###### Description

Project's Git source

###### Type

object

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

#### Registry Url

##### Description

Registry URL to pull the parent devfile from when using id in the parent reference. To ensure the parent devfile gets resolved consistently in different environments, it is recommended to always specify the `registryUrl` when `id` is used.

##### Type

string

#### Starter Projects

##### Description

Overrides of starterProjects encapsulated in a parent devfile. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

array

##### Items

###### Type

object

###### Required

- name

###### One of

| Required |
| --- |
| git |
| zip |

###### Properties

###### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

###### Description

###### Description

Description of a starter project

###### Type

string

###### Git

###### Description

Project's Git source

###### Type

object

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

###### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

###### Sub Dir

###### Description

Sub-directory from a starter project to be used as root for starter project.

###### Type

string

###### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

###### Additional Properties

false

#### Uri

##### Description

URI Reference of a parent devfile YAML file. It can be a full URL or a relative URI with the current devfile as the base URI.

##### Type

string

#### Variables

##### Description

Overrides of variables encapsulated in a parent devfile. Overriding is done according to K8S strategic merge patch standard rules.

##### Type

object

##### Additional Properties

###### Type

string

#### Version

##### Description

Specific stack/sample version to pull the parent devfile from, when using id in the parent reference. To specify `version`, `id` must be defined and used as the import reference source. `version` can be either a specific stack version, or `latest`. If no `version` specified, default version will be used.

##### Type

string

##### Pattern

^(latest)|(([1-9])\.([0-9]+)\.([0-9]+)(\-[0-9a-z-]+(\.[0-9a-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?)$

### Additional Properties

false

## Projects

### Description

Projects worked on in the devworkspace, containing names and sources locations

### Type

array

### Items

#### Type

object

#### Required

- name

#### One of

| Required |
| --- |
| git |
| zip |

#### Properties

##### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

##### Clone Path

###### Description

Path relative to the root of the projects to which this project should be cloned into. This is a unix-style relative path (i.e. uses forward slashes). The path is invalid if it is absolute or tries to escape the project root through the usage of '..'. If not specified, defaults to the project name.

###### Type

string

##### Git

###### Description

Project's Git source

###### Type

object

###### Required

- remotes

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

##### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

##### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

#### Additional Properties

false

## Schema Version

### Description

Devfile schema version

### Type

string

### Pattern

^([2-9])\.([0-9]+)\.([0-9]+)(\-[0-9a-z-]+(\.[0-9a-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$

## Starter Projects

### Description

StarterProjects is a project that can be used as a starting point when bootstrapping new projects

### Type

array

### Items

#### Type

object

#### Required

- name

#### One of

| Required |
| --- |
| git |
| zip |

#### Properties

##### Attributes

###### Description

Map of implementation-dependant free-form YAML attributes.

###### Type

object

###### Additional Properties

true

##### Description

###### Description

Description of a starter project

###### Type

string

##### Git

###### Description

Project's Git source

###### Type

object

###### Required

- remotes

###### Properties

###### Checkout From

###### Description

Defines from what the project should be checked out. Required if there are more than one remote configured

###### Type

object

###### Properties

###### Remote

###### Description

The remote name should be used as init. Required if there are more than one remote configured

###### Type

string

###### Revision

###### Description

The revision to checkout from. Should be branch name, tag or commit id. Default branch is used if missing or specified revision is not found.

###### Type

string

###### Additional Properties

false

###### Remotes

###### Description

The remotes map which should be initialized in the git project. Projects must have at least one remote configured while StarterProjects & Image Component's Git source can only have at most one remote configured.

###### Type

object

###### Additional Properties

###### Type

string

###### Additional Properties

false

##### Name

###### Description

Project name

###### Type

string

###### Max Length

63

###### Pattern

^[a-z0-9]([-a-z0-9]*[a-z0-9])?$

##### Sub Dir

###### Description

Sub-directory from a starter project to be used as root for starter project.

###### Type

string

##### Zip

###### Description

Project's Zip source

###### Type

object

###### Properties

###### Location

###### Description

Zip project's source location address. Should be file path of the archive, e.g. file://$FILE_PATH

###### Type

string

###### Additional Properties

false

#### Additional Properties

false

## Variables

### Description

Map of key-value variables used for string replacement in the devfile. Values can be referenced via {{variable-key}} to replace the corresponding value in string fields in the devfile. Replacement cannot be used for

- schemaVersion, metadata, parent source

- element identifiers, e.g. command id, component name, endpoint name, project name

- references to identifiers, e.g. in events, a command's component, container's volume mount name

- string enums, e.g. command group kind, endpoint exposure

### Type

object

### Additional Properties

#### Type

string

# Additional Properties

false
