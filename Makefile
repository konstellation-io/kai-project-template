# This variable have the environment to use, by default is local, but you can change when you run the make command
ENV ?= local

# Read the PRODUCT_NAME variable based on the file inside the corresponding directory
PRODUCT_NAME := $(shell basename $(wildcard .kai/$(ENV)/*.yaml) .yaml)

# Read the PRODUCT_VERSION variable based on the file inside the corresponding directory
PRODUCT_VERSION := $(shell grep 'version:' .kai/$(ENV)/$(PRODUCT_NAME).yaml | awk '{print $$2}')

# Test for the see the value of the variables
.PHONY: show-vars
show-vars:
	@echo "ENV: $(ENV)"
	@echo "PRODUCT_NAME: $(PRODUCT_NAME)"
	@echo "PRODUCT_VERSION: $(PRODUCT_VERSION)"

# AutoDoc
# -------------------------------------------------------------------------
.PHONY: help
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

.PHONY: login
login: ## Login to the aio platform
	kli server login --client-id kai-kli-oidc --realm konstellation

.PHONY: update-process-env
update-process-env: ## Update process environment
	./scripts/update_process_env.sh

.PHONY: create-product
create-product: ## Push processes images
	kli product create $(PRODUCT_NAME) --description "Kai Project Template"

.PHONY: push-processes-images
push-processes-images: ## Push processes images
	./scripts/push_processes_images.sh $(PRODUCT_NAME)

.PHONY: push-product-version
push-product-version: ## Push new product version
	kli product version push .kai/$(ENV)/$(PRODUCT_NAME).yaml

.PHONY: start-product-version
start-product-version: ## Start the product version
	kli product version start $(PRODUCT_NAME) $(PRODUCT_VERSION) "starting $(PRODUCT_VERSION) version..."

.PHONY: stop-product-version
stop-product-version: ## Stop the product version
	kli product version stop $(PRODUCT_NAME) $(PRODUCT_VERSION) "stopping $(PRODUCT_VERSION) version..."

.PHONY: publish-product-version
publish-product-version: ## Publish the product version skipping the unpublished step
	kli product version publish $(PRODUCT_NAME) $(PRODUCT_VERSION) "publishing $(PRODUCT_VERSION) version..."  --force

.PHONY: send-request
send-request: ## Send a request to the product version
	./scripts/send_request.sh

.PHONY: unpublish-product-version
unpublish-product-version: ## Unpublish the product version
	kli product version unpublish $(PRODUCT_NAME) $(PRODUCT_VERSION) "unpublishing $(PRODUCT_VERSION) version..."

##### HELPERS #####

.PHONY: list-processes-images #
list-processes-images: ## List workflow processes
	kli process-registry ls $(PRODUCT_NAME)

.PHONY: list-product-versions
list-product-versions: ## List product versions
	kli product version list $(PRODUCT_NAME)
