# [Backstage](https://backstage.io)

## Intro

This is a basic Backstage Scaffold App for testing the structure and plugins definitions. This POC uses Forgejo as Git remote server, with a custom plugin to open PRs for new applications to be added to ArgoCD

## Getting started

First you'll need to set up a minimal working environment. You can do that by going into the `localenv` folder and running the `setup.sh` script.

Then just run the following commands to start Backstage:

```sh
yarn install
yarn start
```

## Creating a new Go service

On this POC we only have a new Go Service template. To use it go to `Create` on Backstage frontend, then select `New Go Service` and follow the instructions.
