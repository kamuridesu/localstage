# local environment for backstage local testing

## Set up

Running the `setup.sh` script starts Forgejo in a Docker container with a minimal working structure. It also sets up a minikube cluster with 1 node with ArgoCD.

The script will generate a new `app-config.local.yaml` with Forgejo configs.

## Stopping and cleaning

Just run `stop.sh`. It deletes the Forgejo container and minikube clusters and configs.
