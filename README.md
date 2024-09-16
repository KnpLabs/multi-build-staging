# Multi-build staging environment

THis repository contains a complete configuration to demonstrate the deployment of a multi-build staging environment.

## Requirements

- Docker >= v27.1.2
- Docker compose >= v2.29.2

> The previous requirements are not mandatory, those are the versions on which this configuration has been tested.

## Usage

First you need to initialize the environment and then you can deploy multiple stages and show that changes are only visible to the stage to which they've been applied to.

### Initialize the envorinment

The command below initializes the environment creating the necessary networks and deploying the proxy.

```bash
make init
```

### Deploy a stage

The command below deploys a stage and it can be used multiple times.
The `TAG` parameter is not mandatory and it defaults on the current git branch name.

```bash
TAG=my-feature-1 make deploy-stage
```

For this example The deployed stage will be available via http://my-feature-1.staging.localhost.

> In case the same `TAG` value is re-used the existing tagged stage will be updated.

### Destroy a stage

The command below destroyes the stage matching the given `TAG`.
The `TAG` parameter is not mandatory and it defaults on the current git branch name.

```bash
TAG=my-feature-1 make destroy-stage
```

### Destroy all the stages

The command below destroyes all the existing stages

```bash
make destroy-stages
```

### Destroy the environment

The command below destroyes the whole environment (networks, proxy and stages).

```bash
make destroy
```
