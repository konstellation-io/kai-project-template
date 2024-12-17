#!/bin/bash


URL="kai-project-template.kai.local/demo-workflow-trigger/rest-trigger"

# Call the URL
echo "Making a GET request to $URL..."
response=$(curl $URL)

echo "Response: $response"
