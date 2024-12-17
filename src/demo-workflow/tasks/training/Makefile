# This Makefile contains all helpers for the REST trigger process

# This variable have the environment to use, by default is local, but you can change when you run the make command
ENV ?= local
PROCESS_VERSION ?= v0.0.3

# Read the PRODUCT_NAME variable based on the file inside the corresponding directory
PRODUCT_NAME := $(shell basename $(wildcard ./../../../../.kai/$(ENV)/*.yaml) .yaml)
PROCESS_ID = training


.PHONY: push-image
push-image: ## Push process image in this folder
	kli process-registry register task $(PROCESS_ID) --dockerfile "Dockerfile" --product $(PRODUCT_NAME) --src "." --version $(PROCESS_VERSION)

##### LINTER

.PHONY: linter-py
linter-py: ## Run ruff format
	uv run ruff format
