# Unleash Server

This folder contains the files required for onboarding the [unleash feature toggle service](https://unleash.github.io/) 
 including a postgres database.

For the purpose of just hosting the unleash server, we use a single stage (dev) with direct deployment, see 
 [shipyard.yaml](shipyard.yaml).

## Instructions

1. Create a new project
   ```console
   keptn create project unleash --shipyard=./shipyard.yaml
   ```
2. Onboard unleash and unleash-db using the `keptn onboard service` command:
   ```console
   keptn onboard service unleash-db --project=unleash --chart=./unleash-db
   keptn onboard service unleash --project=unleash --chart=./unleash
   ```
3. Send new artifacts for unleash and unleash-db using the `keptn send new-artifact` command:
   ```console
   keptn send event new-artifact --project=unleash --service=unleash-db --image=postgres:10.4
   keptn send event new-artifact --project=unleash --service=unleash --image=docker.io/keptnexamples/unleash:1.0.0
   ```
4. Get the url (`unleash.unelash-dev.KEPTN_DOMAIN`):
   ```console
   echo http://unleash.unleash-dev.$(kubectl get cm -n keptn ingress-config -o=jsonpath='{.data.ingress_hostname_suffix}')
   ```
5. Open the url in your browser and log in using the following credentials:
   * username: keptn
   * password: keptn
