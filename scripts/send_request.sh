#!/bin/bash


URL="kai-project-template.kai.local/demo-workflow-trigger"

# Call the URL
echo "Making a GET request to $URL..."
response=$(curl -s $URL)

echo "Response: $response"
