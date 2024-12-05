#!/bin/bash

PRODUCT_NAME="kai-project-template"
VERSION="v0.1.0"

SOURCE_PATH="$PWD/src"
DEMO_WORKFLOW_PATH="$SOURCE_PATH/demo-workflow"

echo "Pushing demo workflow processes to registry..."
kli process-registry register trigger trigger --dockerfile "$DEMO_WORKFLOW_PATH/triggers/rest-trigger/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/triggers/rest-trigger" --version $VERSION
kli process-registry register exit exit --dockerfile "$DEMO_WORKFLOW_PATH/exits/training/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/exits/training" --version $VERSION

echo "Done"
