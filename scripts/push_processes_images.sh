#!/bin/bash

# Show help
function show_help() {
    echo "Use: $0 <PRODUCT_NAME>"
    echo
    echo "Description:"
    echo "  Script for pushing demo workflow processes to the registry."
    echo
    echo "Args:"
    echo "  <PRODUCT_NAME>   Name of the product."
    echo
    echo "Sample:"
    echo "  $0 kai-project-template"
    exit 1
}

# Validate input arguments
if [ "$#" -ne 1 ]; then
    echo "Error: Error in the number of arguments."
    show_help
fi

# Read arguments
PRODUCT_NAME=$1

SOURCE_PATH="$PWD/src"
DEMO_WORKFLOW_PATH="$SOURCE_PATH/demo-workflow"

echo "Pushing demo workflow processes to registry..."
echo "Enter the version of the trigger: "
read TRIGGER_VERSION
kli process-registry register trigger trigger --dockerfile "$DEMO_WORKFLOW_PATH/triggers/rest-trigger/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/triggers/rest-trigger" --version $TRIGGER_VERSION
echo "Enter the version of the exit: "
read EXIT_VERSION
kli process-registry register exit exit --dockerfile "$DEMO_WORKFLOW_PATH/exits/training/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/exits/training" --version $EXIT_VERSION

echo "Done"
