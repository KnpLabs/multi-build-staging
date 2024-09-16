TAG := $(shell git rev-parse --abbrev-ref HEAD)

# Public targets
.PHONY: init
init:
	@echo "Initializing the environment"
	$(MAKE) .networks-init
	$(MAKE) .proxy-deploy
	@echo "Environment initialized"

.PHONY: deploy
deploy:
	@echo "Deploying the feature branch"
	$(MAKE) .feature-branch-deploy
	@echo "Feature branch deployed"

.PHONY: destroy
destroy:
	@echo "Destroying the feature branch"
	$(MAKE) .feature-branch-destroy
	$(MAKE) .proxy-destroy
	$(MAKE) .networks-destroy
	@echo "Feature branch destroyed"

# Networks
.PHONY: .networks-init
.networks-init:
	@echo "Initializing networks"
	@docker network create --driver overlay --attachable proxy
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
	$(MAKE) .feature-branch-build-images
	$(MAKE) .feature-branch-push-images
	$(MAKE) .feature-branch-start
	@echo "Feature branch '${TAG}' deployed"

.PHONY: .feature-branch-build-images
.feature-branch-build-images:
	@echo "Building feature branch's Docker images"
	@docker-compose -f code/docker-compose.yaml -p $(TAG) build

.PHONY: .feature-branch-push-images
.feature-branch-push-images:
	@echo "Pushing feature branch's Docker images"

.PHONY: .feature-branch-start
.feature-branch-start:
	@echo "Starting feature branch's stack"
	@docker-compose -f code/docker-compose.yaml -p $(TAG) up -d

.PHONY: .feature-branch-destroy
.feature-branch-destroy:
	@docker-compose -f code/docker-compose.yaml down
