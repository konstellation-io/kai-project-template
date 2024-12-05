#!/bin/bash

# Show help
function show_help() {
    echo "Uso: $0 <PRODUCT_NAME> <VERSION>"
    echo
    echo "Descripción:"
    echo "  Script para registrar imágenes de procesos en el registro."
    echo
    echo "Argumentos:"
    echo "  <PRODUCT_NAME>   Nombre del producto."
    echo "  <VERSION>        Versión del producto."
    echo
    echo "Ejemplo:"
    echo "  $0 kai-project-template v0.1.0"
    exit 1
}

# Validate input arguments
if [ "$#" -ne 2 ]; then
    echo "Error: Número incorrecto de argumentos."
    show_help
fi

# Leer argumentos
PRODUCT_NAME=$1
VERSION=$2

SOURCE_PATH="$PWD/src"
DEMO_WORKFLOW_PATH="$SOURCE_PATH/demo-workflow"

echo "Pushing demo workflow processes to registry..."
kli process-registry register trigger trigger --dockerfile "$DEMO_WORKFLOW_PATH/triggers/rest-trigger/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/triggers/rest-trigger" --version $VERSION
kli process-registry register exit exit --dockerfile "$DEMO_WORKFLOW_PATH/exits/training/Dockerfile" --product $PRODUCT_NAME --src "$DEMO_WORKFLOW_PATH/exits/training" --version $VERSION

echo "Done"
