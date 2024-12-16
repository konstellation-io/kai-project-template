# This Makefile contains all helpers for the REST trigger process

# This variable have the environment to use, by default is local, but you can change when you run the make command
ENV ?= local
PROCESS_VERSION ?= v0.0.1

# Read the PRODUCT_NAME variable based on the file inside the corresponding directory
PRODUCT_NAME := $(shell basename $(wildcard ./../../../../.kai/$(ENV)/*.yaml) .yaml)
PROCESS_ID = exit


.PHONY: push-image
push-image: ## Login to the aio platform
	kli process-registry register exit $(PROCESS_ID) --dockerfile "Dockerfile" --product $(PRODUCT_NAME) --src "." --version $(PROCESS_VERSION)

##### LINTER

.PHONY: linter-py
linter-py: ## Run ruff format
	uv run ruff format
