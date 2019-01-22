# First-Example
This example shows how to ...

##### Table of Contents
 * [Step Zero: Prerequisites](#step-zero)
 * [Step One: Provision cluster on Kubernetes](#step-one)
 * [Step Two: Setup service tagging and process group naming in Dynatrace](#step-two)
 * [Step Three: Lab execution](#step-three)
 * [Step Four: Cleanup](#step-four)

## Step Zero: Prerequisites <a id="step-zero"></a>

This example assumes that you have a working cluster. See the [Getting Started Guides](https://kubernetes.io/docs/setup/) for details about creating a cluster.

* [jq](https://stedolan.github.io/jq/) has to be installed to run the setup script
* A GitHub organization to fork the sockshop application to
* A GitHub personal access token
* kubectl CLI, which is logged in to your cluster
* Git CLI and [Hub CLI](https://hub.github.com/)
* Dynatrace Tenant: Dynatrace `Tenant ID`, a Dynatrace `API Token` and Dynatrace `PaaS Token`

## Step One: Provision cluster on Kubernetes <a id="step-one"></a>

This directory contains all scripts and instructions needed to deploy the ACM Sockshop demo on a Kubernetes Cluster.

1. Execute the `forkGitHubRepositories.sh` script in the `scripts` directory. This script takes the name of the GitHub organization you have created earlier.

    ```console
    $ ./scripts/forkGitHubRepositories.sh <GitHubOrg>
    ```

    This script `clone`s all needed repositories and the uses the `hub` command ([hub](https://hub.github.com/)) to fork those repositories to the passed GitHub organization. After that, the script deletes all repositories and `clone`s them again from the new URL.
    
1. Insert information in ./scripts/creds.json by executing *./scripts/creds.sh* - This script will prompt you for all information needed to complete the setup, and populate the file *scripts/creds.json* with them. (If for some reason there are problems with this script, you can of course also directly enter the values into creds.json).

    ```console
    $ ./scripts/creds.sh
    ```
    
1. Execute *./scripts/setup-infrastructure.sh* - This will deploy a Jenkins service within your OpenShift Cluster, as well as an initial deployment of the sockshop application in the *dev*, *staging* and *production* namespaces. NOTE: If you use a Mac, you can use the script *setup-infrastructure-macos.sh*.
*Note that the script will run for some time (~5 mins), since it will wait for Jenkins to boot and set up some credentials via the Jenkins REST API.*

    ```console
    $ ./scripts/setup-infrastructure.sh
    ```
    
1. Afterwards, you can login using the default Jenkins credentials (admin/AiTx4u8VyUV8tCKk). It's recommended to change these credentials right after the first login. You can get the URL of Jenkins by executing

    ```console
    $ kubectl get svc jenkins -n cicd
    ``` 

1. Verify the installation: In the Jenkins dashboard, you should see the following pipelines:

* k8s-deploy-production
* k8s-deploy-production-canary
* k8s-deploy-production-update
* k8s-deploy-staging
* A folder called *sockshop*

![](./assets/jenkins-dashboard.png)

Further, navigate to Jenkins > Manage Jenkins > Configure System, and see if the Environment Variables used by the build pipelines have been set correctly (Note that the value for the parameter *DT_TENANT_URL* should start with 'https://'):

![](./assets/jenkins-env-vars.png)

1. Verify your deployment of the Sockshop service: Execute the following commands to retrieve the URLs of your front-end in the dev, staging and production environments:

    ```console
    $ kubectl get svc front-end -n dev
    ```

    ```console
    $ kubectl get svc front-end -n staging
    ```

    ```console
    $ kubectl get svc front-end -n production
    ```

## Step Two: Setup service tagging and process group naming in Dynatrace <a id="step-two"></a>

This allows you to query service-level metrics (e.g.: Response Time, Failure Rate, or Throughput) automatically based on meta-data that you have passed during a deployment, e.g.: *Service Type* (frontend, backend), *Deployment Stage* (dev, staging, production). Besides, this lab creates tagging rules based on Kubernetes namespace and Pod name.

In order to tag services, Dynatrace provides **Automated Service Tag Rules**. In this lab you want Dynatrace to create a new service-level tag with the name **SERVICE_TYPE**. It should only apply the tag *if* the underlying Process Group has the custom meta-data property **SERVICE_TYPE**. If that is the case, you also want to take this value and apply it as the tag value for **Service_Type**.

1. Create a Naming Rule for Process Groups

    1. Go to **Settings**, **Process groups**, and click on **Process group naming**.
    1. Create a new process group naming rule with **Add new rule**. 
    1. Edit that rule:
        * Rule name: `Container.Namespace`
        * Process group name format: `{ProcessGroup:KubernetesContainerName}.{ProcessGroup:KubernetesNamespace}`
        * Condition: `Kubernetes namespace`> `exits`
    1. Click on **Preview** and **Save**.

Screenshot shows this rule definition.
![tagging-rule](./assets/pg_naming.png)

1. Create Service Tag Rule
    1. Go to **Settings**, **Tags**, and click on **Automatically applied tags**.
    1. Create a new custom tag with the name `SERVICE_TYPE`.
    1. Edit that tag and **Add new rule**.
        * Rule applies to: `Services` 
        * Optional tag value: `{ProcessGroup:Environment:SERVICE_TYPE}`
        * Condition on `Process group properties -> SERVICE_TYPE` if `exists`
    1. Click on **Preview** to validate rule works.
    1. Click on **Save** for the rule and then **Done**.

Screenshot shows this rule definition.
![tagging-rule](./assets/tagging_rule.png)

3. Search for Services by Tag
It will take about 30 seconds until the tags are automatically applied to the services.
    1. Go to **Transaction & services**.
    1. Click in **Filtered by** edit field.
    1. Select `SERVICE_TYPE` and select `FRONTEND`.
    1. You should see the service `front-end`. Open it up.

4. Create Service Tag for App Name based on K8S Container Name
    1. Go to **Settings**, **Tags**, and click on **Automatically applied tags**.
    1. Create a new custom tag with the name `app`.
    1. Edit that tag and **Add new rule**.
        * Rule applies to: `Services` 
        * Optional tag value: `{ProcessGroup:KubernetesContainerName}`
        * Condition on `Kubernetes container name` if `exists`
    1. Click on **Preview** to validate rule works.
    1. Click on **Save** for the rule and then **Done**.

5. Create Service Tag for Environment based on K8S Namespace
    1. Go to **Settings**, **Tags**, and click on **Automatically applied tags**.
    1. Create a new custom tag with the name `environment`.
    1. Edit that tag and **Add new rule**.
        * Rule applies to: `Services` 
        * Optional tag value: `{ProcessGroup:KubernetesNamespace}`
        * Condition on `Kubernetes namespace` if `exists`
    1. Click on **Preview** to validate rule works.
    1. Click on **Save** for the rule and then **Done**.

## Step Three: Lab execution <a id="step-three"></a>

* [Performance as a Service](./labs/performance-as-a-service) 
* [Production Deployments](./labs/production-deployments) 
* [Runbook Automation and Self-Healing](./labs/runbook-automation-and-self-healing) 
* [Unbreakable Delivery Pipeline](./labs/unbreakable-delivery-pipeline)

## Step Four: Cleanup <a id="step-four"></a>