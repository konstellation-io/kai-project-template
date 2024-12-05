VERSION ?= v0.1.0
ENV ?= local
PRODUCT_NAME ?= kai-project-template

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
	./scripts/push_processes_images.sh

.PHONY: push-product-version
push-product-version: ## Push new product version
	kli product version push .kai/$(ENV)/$(PRODUCT_NAME).yaml

.PHONY: start-product-version
start-product-version: ## Start the product version
	kli product version start $(PRODUCT_NAME) $(VERSION)

.PHONY: stop-product-version
stop-product-version: ## Stop the product version
	kli product version stop $(PRODUCT_NAME) $(VERSION)

.PHONY: publish-product-version
publish-product-version: ## Publish the product version skipping the unpublished step
	kli product version publish $(PRODUCT_NAME) $(VERSION) --force

.PHONY: unpublish-product-version
unpublish-product-version: ## Unpublish the product version
	kli product version unpublish $(PRODUCT_NAME) $(VERSION)
