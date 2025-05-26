Quick start with odo v3
=======================

This guide will run through creating a simple hello world devfile project using `odo` version 3. The purpose of this guide is to provide a practical introduction to those just starting out with devfiles.

Procedure
---------

1.  Access or setup your target cluster
    
    *   (Optional) You can use `minikube` to run your cluster locally, follow [these](https://minikube.sigs.k8s.io/docs/start/) steps to get started
2.  Install `odo` version 3 if you do not already have it by following the [Installation guide](https://odo.dev/docs/overview/installation)
    
3.  Once installed, use `odo login` to login with your cluster credentials
    
    *   This step is not needed if using `minikube`
4.  Create a directory to store a simple [hello world Express.js](https://expressjs.com/en/starter/hello-world.html) application
    
    #### package.json file:
    
    ```json
        {
            "name": "helloworld-example",
            "version": "1.0.0",
            "description": "",
            "main": "app.js",
            "type": "module",
            "dependencies": {
                "@types/express": "^4.17.17",
                "express": "^4.18.2"
            },
            "scripts": {
                "start": "node app.js"
            }
        }
    ```
    
    #### Application source code app.js:
    
    ```python
        import express from "express"
        
        
        const PORT = 3000
        const app = express()
        
        
        app.get("/", (req, res) => {
            res.send("Hello world!")
        })
        
        
        app.listen(PORT, () => {
            console.log(`Listening on port ${PORT}..`)
        })
    ```
    
5.  (Optional) Normally it is recommended to use `odo init` to start your project from a devfile registry stack, see [Developing with Node.JS](https://odo.dev/docs/user-guides/quickstart/nodejs#step-2-initializing-your-application-odo-init) and [Command Reference: odo init](https://odo.dev/docs/command-reference/init) for details, steps 6-11 will go through the process of making the devfile from scratch
    
    *   For this project, run `odo init --name helloworld-example --devfile nodejs`, to test this devfile in action, skip to step 12
6.  Create a devfile with the filename `.devfile.yaml`. Add the `schemaVersion` field with the desired devfile specification version to use
    
    ```yaml
        schemaVersion: 2.3.0
    ```
    
7.  Next, create the first component to serve as the runtime for the project, for this use the `container`component with the name `runtime` and the `node:18-alpine` image
    
    *   `name` is the identifier used to refer to the component
        
    *   `image` is the container image to use for the component
        
        ```yaml        
             schemaVersion: 2.3.0
             components:
               - name: runtime
                 container:
                   image: node:18-alpine
        ```    
        
8.  The `runtime` container hosts the expressjs app created which listens on port `3000`, define this port in the component by specifying an entry under `endpoints`
    
    *   Each endpoint has at least a `name` to identify them and the `targetPort` to specify the port number to forward
        
        ```yaml
             schemaVersion: 2.3.0
             components:
               - name: runtime
                 container:
                   image: node:18-alpine
                   endpoints:
                     - name: http-3000
                       targetPort: 3000
        ```    
        
9.  Now that the `runtime` container is defined, `commands` are needed to tell `odo` what to do during the step of the [development runtime](https://odo.dev/docs/overview/dev_and_deploy#when-should-i-use-odo-dev) (`odo dev`). Define the command to install the dependencies needed to run the application (`npm install`)
    
    *   The `id` field identifies the command by a label which can be used to specify which command to run by the dev tool
        *   Example: `odo dev --build-command install`
    *   An `exec` command specifies explicit shell command(s) to run on a given `component`
    *   `commandLine` defines the shell command(s) to execute as part of that devfile command
    *   The `group` specifies what `kind` of command it is or if it is the default of its kind, `isDefault`
        *   `build` commands runs before `run` commands
            
            ```yaml          
                 schemaVersion: 2.3.0
                 components:
                   - name: runtime
                     container:
                       image: node:18-alpine
                       endpoints:
                         - name: http-3000
                           targetPort: 3000
                 commands:
                   - id: install
                     exec:
                       commandLine: npm install
                       component: runtime
                       workingDir: ${PROJECT_SOURCE}
                       group:
                         isDefault: true
                         kind: build
            ```    
            
10.  Next, define the command to run the application (`node app.js`):
        
      ```yaml
         schemaVersion: 2.3.0
         components:
           - name: runtime
             container:
               image: node:18-alpine
               endpoints:
                 - name: http-3000
                   targetPort: 3000
         commands:
           - id: install
             exec:
               commandLine: npm install
               component: runtime
               workingDir: ${PROJECT_SOURCE}
               group:
                 isDefault: true
                 kind: build
           - id: run
             exec:
               commandLine: node app.js
               component: runtime
               workingDir: ${PROJECT_SOURCE}
               group:
                 isDefault: true
                 kind: run
        ```
    
11.  Now the devfile is ready to be used to run the application:

      ```yaml
        schemaVersion: 2.3.0
        components:
          - name: runtime
            container:
              image: node:18-alpine
              endpoints:
                - name: http-3000
                  targetPort: 3000
        commands:
          - id: install
            exec:
              commandLine: npm install
              component: runtime
              workingDir: ${PROJECT_SOURCE}
              group:
                isDefault: true
                kind: build
          - id: run
            exec:
              commandLine: node app.js
              component: runtime
              workingDir: ${PROJECT_SOURCE}
              group:
                isDefault: true
                kind: run
      ```
    
12.  Run `odo dev` and you should see the following output:
    
      ```
         __
        /  \__     Developing using the "helloworld-devfile" Devfile
        \__/  \    Namespace: default
        /  \__/    odo version: v3.9.0
        \__/
        
        
        ⚠  You are using "default" namespace, odo may not work as expected in the default namespace.
        ⚠  You may set a new namespace by running `odo create namespace <name>`, or set an existing one by running `odo set namespace <name>`
        
        
        ↪ Running on the cluster in Dev mode
        •  Waiting for Kubernetes resources  ...
        ⚠  Pod is Pending
        ✓  Pod is Running
        ✓  Syncing files into the container [401ms]
        ✓  Building your application in container (command: install) [1s]
        •  Executing the application (command: run)  ...
        -  Forwarding from 127.0.0.1:20001 -> 3000
        
        
        
        
        ↪ Dev mode
        Status:
        Watching for changes in the current directory /path/to/project
        
        
        Keyboard Commands:
        [Ctrl+c] - Exit and delete resources from the cluster
            [p] - Manually apply local changes to the application on the cluster
      ```
    
13.  The application port `3000` served in the cluster gets routed to your host on a different port (in this case `20001`). Run `curl http://localhost:20001` and you should see the following output:
    
      ```
        Hello world!%
      ```
    
14.  Congratulations! You have written your first devfile project with `odo`!
    

Quick start with Eclipse Che
============================

This guide will run through creating a simple hello world devfile project using Eclipse Che. The purpose of this guide is to provide a practical introduction to those just starting out with devfiles.

Procedure
---------

1.  Obtain access to Eclipse Che if you do not already have it, as an individual this can be done by setting up a [local instance of Eclipse Che](https://www.eclipse.dev/che/docs/stable/administration-guide/installing-che-locally/)
    
    *   You can use `minikube` to run your cluster locally, follow [these](https://minikube.sigs.k8s.io/docs/start/) steps to get started
    *   An alternative is to use the [Eclipse Che hosted by Red Hat](https://developers.redhat.com/developer-sandbox/ide), see [the corresponding guide](https://www.eclipse.dev/che/docs/stable/hosted-che/hosted-che/) in Eclipse Che documentation if this method is used
2.  For this quick start guide, we will create a simple [hello world Express.js](https://expressjs.com/en/starter/hello-world.html) application
    
3.  In Eclipse Che, create an empty workspace
    
4.  Create the files which make up the simple [hello world Express.js](https://expressjs.com/en/starter/hello-world.html) application
    
    #### package.json file:
    
    ```json
        {
            "name": "helloworld-devfile",
            "version": "1.0.0",
            "description": "",
            "main": "app.js",
            "type": "module",
            "dependencies": {
                "@types/express": "^4.17.17",
                "express": "^4.18.2"
            }
        }
    ```
    
    #### Application source code app.js
    
    ```python
        import express from "express"
        
        
        const PORT = 3000
        const app = express()
        
        
        app.get("/", (req, res) => {
            res.send("Hello world!")
        })
        
        
        app.listen(PORT, () => {
            console.log(`Listening on port ${PORT}..`)
        })
    ```
    
5.  Create a devfile with the filename `.devfile.yaml`. The devfile should be populated with content similar to the following
    
    *   The `schemaVersion` of the devfile can to set to the desired devfile specification version to use
        
        *   It is recommended to use the latest release, currently `2.2.0`
    *   The `metadata.name` field is the name of the workspace for the project
        
        ```yaml        
            schemaVersion: 2.3.0
            metadata:
              name: helloworld-example
        ```    
        
6.  Next, create the first component to serve as the dev environment for the project, for this use the `container` component with the name `dev-tooling` and the `quay.io/devfile/universal-developer-image:latest` image
    
    *   `name` is the identifier used to refer to the component
        
    *   `image` is the container image to use for the component, `quay.io/devfile/universal-developer-image` is the default development tooling image used by Eclipse Che with multiple programming languages supports (including Node.js).
        
        ```yaml
             schemaVersion: 2.3.0
             metadata:
               name: helloworld-example
             components:
               - name: dev-tooling
                 container:
                   image: quay.io/devfile/universal-developer-image:ubi8-latest
        ```    
        
7.  The `dev-tooling` container will host the expressjs app which listens on port `3000`, define this port in the component by specifying an entry under `endpoints`
    
    *   Each endpoint has at least a `name` to identify them and the `targetPort` to specify the port number to forward
        
        ```yaml        
             schemaVersion: 2.3.0
             metadata:
               name: helloworld-example
             components:
               - name: dev-tooling
                 container:
                   image: quay.io/devfile/universal-developer-image:ubi8-latest
                   endpoints:
                     - name: http-3000
                       targetPort: 3000
        ```    
        
8.  Now that the `dev-tooling` container is defined, `commands` are useful to add in the IDE (the default is VS Code) some UI elements to guide developers during the development cycle. Define the command to install the dependencies needed to run the application (`npm install`)
    
    *   The `id` field identifies the command so that it can be referenced in events or composite commands.
        
    *   An `exec` command specifies explicit shell command(s) to run on a given `component`
        
    *   `commandLine` defines the shell command(s) to execute as part of that devfile command
        
    *   The `group` specifies what `kind` of command it is or if it is the default of its kind, `isDefault`
        
        ```yaml        
            commands:
              - id: install
                exec:
                  commandLine: npm install
                  component: dev-tooling
                  workingDir: ${PROJECT_SOURCE}
                  group:
                    isDefault: true
                    kind: build
        ```    
        
9.  Next, define the command to run the application (`node app.js`)
    
    ```yaml
        commands:
          - id: run
            exec:
              commandLine: node app.js
              component: dev-tooling
              workingDir: ${PROJECT_SOURCE}
              group:
                isDefault: true
                kind: run
    ```
    
10.  Now the devfile is ready to be used to run the application with Eclipse Che
    
      ```yaml
          schemaVersion: 2.3.0
          metadata:
            name: helloworld-example
          components:
            - name: dev-tooling
              container:
                image: quay.io/devfile/universal-developer-image:ubi8-latest
                endpoints:
                  - name: http-3000
                    targetPort: 3000
          commands:
            - id: install
              exec:
                commandLine: npm install
                component: dev-tooling
                workingDir: ${PROJECT_SOURCE}
                group:
                  isDefault: true
                  kind: build
            - id: run
              exec:
                commandLine: node app.js
                component: dev-tooling
                workingDir: ${PROJECT_SOURCE}
                group:
                  isDefault: true
                  kind: run
        ```  
    
11.  Click 'Eclipse Che' in the bottom left corner, then select 'Eclipse Che: Restart Workspace from Local Devfile' to reload the workspace with the new devfile
    
12.  Once the workspace has finished restarting, run the `install` command by opening the menu, open 'Terminal/Run Task', under the 'Run Task' menu open 'devfile/devfile: install', the task should open a terminal with the following
    
      ```
    
         *  Executing task: devfile: install 
        
        
        
        
        added 67 packages, and audited 68 packages in 8s
        
        
        7 packages are looking for funding
          run `npm fund` for details
        
        
        found 0 vulnerabilities
        npm notice 
        npm notice New major version of npm available! 8.3.1 -> 9.6.5
        npm notice Changelog: https://github.com/npm/cli/releases/tag/v9.6.5
        npm notice Run npm install -g [email protected] to update!
        npm notice 
         *  Terminal will be reused by tasks, press any key to close it.
      ```
    
13.  Run the application with the `run` command by going through the same steps as `install` but under the 'Run Task' menu open 'devfile/devfile: run', the task should open. The `run` command will execute until the user interrupts it, such as killing it with _Ctrl-C_

        ```    
            Executing task: devfile: run         
    
            Listening on port 3000..
        ```
    
14.  Under the 'EXPLORER', expand the 'ENDPOINTS' panel and copy the `http-3000` endpoint URL
    
15.  Paste the endpoint URL in a new tab and the response should just show "Hello World!"
    
16.  (Optional) Normally when creating a workspace it is recommended to use a sample under 'Select a Sample' from the embedded devfile registry to start your project, a similar devfile project workspace can be created using the 'Node.js Express Web Application' sample
    
17.  Congratulations! You have written your first devfile project with Eclipse Che!



Developing with devfiles
========================

A devfile is a `yaml` file. After you include it in your local environment, the devfile provides ways to automate your processes. Tools like `odo` run the devfile and apply its guidelines to your environment. You can configure the devfile based on your unique development needs.

To get a better understanding of what devfiles can help build, take a look at a few tools that currently support devfile.

Quick start guides
------------------

*   Use the devfile specification to develop a Node.js “Hello World” application using `odo`. Developing this application introduces you to how a devfile automates and simplifies your development process.
    *   [Quick start with odo v3](/docs/2.3.0/quickstart-odo)
    *   Get started with [odo](https://odo.dev/docs/user-guides/quickstart/nodejs).
*   Create a workspace in `Eclipse Che` with a community sample backed by the devfile specification to start building your application in the language of your choice.
    *   [Quick start with Eclipse Che](/docs/2.3.0/quickstart-che)
    *   Get started with [Eclipse Che](https://www.eclipse.dev/che/).
*   Use blueprints in `Amazon CodeCatalyst` to quickly build a "Modern three-tier web application". Start working on the source code with a Dev Environment that uses a devfile to pre-determine and install the required project tools and application libraries.
    *   Get started with [Amazon CodeCatalyst](https://docs.aws.amazon.com/codecatalyst/latest/userguide/getting-started-template-project.html).
*   Set up a remote development environment that links to your Git repository using `JetBrains Space Cloud Dev` and the devfile specification.
    *   Get started with [JetBrains Space Cloud Dev Environments](https://blog.jetbrains.com/space/2022/10/26/get-started-with-space-dev-environments/).

Tools that provide devfile support
----------------------------------

*   [odo](https://odo.dev/)
    
*   [Eclipse Che](https://medium.com/eclipse-che-blog/devfile-v2-and-ide-plug-ins-in-eclipse-che-7a560ae724b1)
    
*   [OpenShift Dev Console](https://github.com/openshift/console#openshift-console)
    
*   [VSCode OpenShift Toolkit](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-openshift-connector)
    
*   [IntelliJ OpenShift Toolkit](https://plugins.jetbrains.com/plugin/12030-openshift-connector-by-red-hat)
    
*   [Amazon CodeCatalyst](https://docs.aws.amazon.com/codecatalyst/latest/userguide/devenvironment.html)
    
*   [JetBrains Space](https://blog.jetbrains.com/space/2022/05/04/space-dev-environments-support-for-rider-devfile-configuration-and-more/#devfiles)


Integrate with editors
======================

The [YAML Language Server](https://github.com/redhat-developer/yaml-language-server) provides validation, document outlining, auto-completion, hover support, and formatting for YAML files. To provide IntelliSense for devfiles, the YAML Language Server pulls all available schemas from the [JSON Schema Store](https://www.schemastore.org/json/). The devfile team maintains the devfile JSON Schema stored within the JSON Schema Store.

Walk through
------------

Download
--------

### VSCode Plugin

If you are using [VSCode](https://code.visualstudio.com/), you can install the [YAML VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) from the Marketplace. The YAML VSCode Plugin is built and maintained by Red Hat.

### Other Editor Plugins

Other editor plugins can be found in the YAML Language Server [GitHub Repository](https://github.com/redhat-developer/yaml-language-server#clients).

Access the latest version
-------------------------

Press `Ctrl + Shift + P` and type `Preferences: Open User Settings (JSON)`. This opens your user settings. Inside the user settings, add the following snippet:

```json
    {
      ...
      "yaml.schemas": {
        "https://raw.githubusercontent.com/devfile/api/main/schemas/latest/devfile.json": "devfile.yaml"
      },
      ...
    }
```    
    
Devfile validation rules
========================

Id and name:
------------

`^[a-z0-9]([-a-z0-9]*[a-z0-9])?$`

The restriction is added to allow easy translation to K8s resource names, and also to have consistent rules for both `name` and `id` fields.

The validation will be done as part of schema validation, the rule will be introduced as a regex in schema definition, any objection of the rule in devfile will result in a failure.

*   Limit to lowercase characters i.e., no uppercase allowed
*   Limit within 63 characters
*   No special characters allowed except dash(-)
*   Start with an alphanumeric character
*   End with an alphanumeric character

Endpoints:
----------

*   All the endpoint names are unique across components
*   Endpoint ports must be unique across `container` components -- two `container` components cannot have the same `targetPort`, but one `container` component may have two endpoints with the same `targetPort`. This restriction does not apply to `container` components with `dedicatedPod` set to `true`.

Commands:
---------

1.  `id` must be unique
2.  `composite` command:
    *   Should not reference itself via a subcommand
    *   Should not indirectly reference itself via a subcommand which is a `composite` command
    *   Should reference a valid devfile command
3.  `exec` command should: map to a valid `container` component
4.  `apply` command should: map to a valid `container`/`kubernetes`/`openshift`/`image` component
5.  `{build, run, test, debug, deploy}`, each kind of group can only have one default command associated with it. If there are multiple commands of the same kind without a default, a warning will be displayed.

Components:
-----------

Common rules for all components types:

*   `name` must be unique

### Container component

1.  The container components must reference a valid volume component if it uses volume mounts, and the volume components are unique
2.  `PROJECT_SOURCE` or `PROJECTS_ROOT` are reserved environment variables defined under env, cannot be defined again in `env`
3.  The annotations should not have conflict values for same key, except deployment annotations and service annotations set for a container with `dedicatedPod=true`
4.  Resource requirements, e.g. `cpuLimit`, `cpuRequest`, `memoryLimit`, `memoryRequest`, must be in valid quantity format; and the resource requested must be less than the resource limit (if specified).

### Plugin component

*   Commands in plugins components share the same commands validation rules as listed above. Validation occurs after overriding and merging, in flattened devfile
*   Registry URL needs to be in valid format

### Kubernetes & OpenShift component

*   `uri` needs to be a valid URI format

### Image component

*   An `image` component's git source cannot have more than one remote defined. If checkout remote is mentioned, validate it against the remote configured map

Events:
-------

1.  `preStart` and `postStop` events can only be `apply` commands
2.  `postStart` and `preStop` events can only be `exec` commands
3.  If `preStart` and `postStop` events refer to a `composite` command, then all containing commands need to be `apply` commands.
4.  If `postStart` and `preStop` events refer to a `composite` command, then all containing commands need to be `exec` commands.

Parent:
-------

*   Share the same validation rules as listed above. Validation occurs after overriding and merging, in flattened devfile

Starter projects:
-----------------

*   Starter project entries cannot have more than one remote defined
*   If `checkoutFrom.remote` is mentioned, validate it against the starter project remote configured map

Projects
--------

*   `checkoutFrom.remote` is mandatory if more than one remote is configured
*   If checkout remote is mentioned, validate it against the starter project remote configured map    
