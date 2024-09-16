TAG ?= $(shell git rev-parse --abbrev-ref HEAD)

# Public targets
.PHONY: init
init:
	@echo "Initializing the environment"
	$(MAKE) .networks-init
	$(MAKE) .proxy-deploy
	@echo "Environment initialized"

.PHONY: destroy
destroy:
	@echo "Destroying the environment"
	$(MAKE) destroy-stages
	$(MAKE) .proxy-destroy
	$(MAKE) .networks-destroy
	@echo "Environment destroyed"

.PHONY: deploy-stage
deploy-stage:
	@echo "Deploying the ${TAG} stage"
	$(MAKE) .feature-branch-deploy
	@echo "Stage ${TAG} deployed"

.PHONY: destroy-stages
destroy-stages:
	@echo "Destroying all stages"
	@docker container ls --filter "label=stage" --format="{{.Labels}}" | sed -un "s/^.*stage=\([^,]*\).*$$/\1/p" | xargs --no-run-if-empty -L1 -I {} $(MAKE) destroy-stage TAG={}
	@echo "All stages destroyed"

.PHONY: destroy-stage
destroy-stage:
	@echo "Destroying the ${TAG} stage"
	$(MAKE) .feature-branch-destroy
	@echo "Stage ${TAG} destroyed"

# Networks
.PHONY: .networks-init
.networks-init:
	@echo "Initializing networks"
	-@docker network create proxy
	@echo "Networks initialized"

.PHONY: .networks-destroy
.networks-destroy:
	@echo "Destroying networks"
	@docker network remove proxy
	@echo "Networks destroyed"

# Proxy
.PHONY: .proxy-deploy
.proxy-deploy:
	@echo "Deploying the proxy"
	$(MAKE) .proxy-build-images
	$(MAKE) .proxy-push-images
	$(MAKE) .proxy-start
	@echo "Proxy deployed"

.PHONY: .proxy-build-images
.proxy-build-images:
	@echo "Building proxy's Docker images"
	@docker-compose -f proxy/docker-compose.yaml build

.PHONY: .proxy-push-images
.proxy-push-images:
	@echo "Pushing proxy's Docker images"

.PHONY: .proxy-start
.proxy-start:
	@echo "Starting proxy's stack"
	@docker-compose -f proxy/docker-compose.yaml up -d

.PHONY: .proxy-destroy
.proxy-destroy:
	@docker-compose -f proxy/docker-compose.yaml down

# Code
.PHONY: .feature-branch-deploy
.feature-branch-deploy:
	@echo "Deploying the '${TAG}' feature branch"
	$(MAKE) .feature-branch-init-environment-variables
	$(MAKE) .feature-branch-build-images
	$(MAKE) .feature-branch-push-images
	$(MAKE) .feature-branch-start
	$(MAKE) .feature-branch-database-init
	$(MAKE) .feature-branch-database-migrations
	$(MAKE) .feature-branch-database-load-fixtures
	@echo "Feature branch '${TAG}' deployed"

.PHONY: .feature-branch-init-environment-variables # out of the scope of the demo
.feature-branch-init-environment-variables:
	@echo "Initializing environment variables"

.PHONY: .feature-branch-build-images
.feature-branch-build-images:
	@echo "Building feature branch's Docker images"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) build

.PHONY: .feature-branch-push-images # out of the scope of the demo
.feature-branch-push-images:
	@echo "Pushing feature branch's Docker images"

.PHONY: .feature-branch-start
.feature-branch-start:
	@echo "Starting feature branch's stack"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) up -d

.PHONY: .feature-branch-database-init
.feature-branch-database-init:
	@echo "Initializing the feature branch's database"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) exec php bin/console doctrine:database:create --if-not-exists --no-interaction --quiet
	@echo "Feature branch's database initialized"

.PHONY: .feature-branch-database-migrations
.feature-branch-database-migrations:
	@echo "Executing migrations on the feature branch's database"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) exec php bin/console doctrine:migrations:migrate --no-interaction --quiet
	@echo "Feature branch's migrations executed"

.PHONY: .feature-branch-database-load-fixtures
.feature-branch-database-load-fixtures:
	@echo "Loading fixtures on the feature branch's database"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) exec php bin/console doctrine:fixtures:load --no-interaction --quiet
	@echo "Feature branch's fixtures loaded"

.PHONY: .feature-branch-destroy
.feature-branch-destroy:
	@echo "Destroying the ${TAG} feature branch's stack"
	@export TAG=$(TAG) && docker-compose -f code/docker-compose.yaml -p $(TAG) down
	@echo "${TAG} feature branch's destroyed"
