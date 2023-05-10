#!/bin/bash

# Check if VAULT_ADDR environment variable is set
if [ -z "$VAULT_ADDR" ]; then
    echo "Error: VAULT_ADDR environment variable not set"
    exit 1
fi

# Check if VAULT_TOKEN environment variable is set
if [ -z "$VAULT_TOKEN" ]; then
    echo "Error: VAULT_TOKEN environment variable not set"
    exit 1
fi

# Define the root endpoint to start calling the API
root_endpoint="$VAULT_ADDR/v1/sys/namespaces?list=true"

# Define the output file path and name
output_file="VaultNamespaceList.txt"

# Test and Echo the Namespace selected
if [ -z "$1" ]
then
    echo "Default Root Namespace selected"
    # Create file (or erase)
    echo "/" > "$output_file"
else
    cmd=$(curl -sX 'GET' $root_endpoint -H 'accept: */*' -H 'X-Vault-Token: '$VAULT_TOKEN -H 'X-Vault-Namespace:'"$1" | cut -d'"' -f2)
    if [ $cmd == errors ]
    then
        echo "Error: Namespace does not exist"
        exit
    else
        # Create file (or erase)
        echo "$1" > "$output_file" 
        echo "Namespace: "$1" selected"
    fi
fi

# Define a function to call the API and extract any child Namespaces
function call_api {
    local ns=$1
    
    # Call the API endpoint and save the response to a temporary file
    response_file=$(mktemp)
    curl -sX 'GET' $root_endpoint -H 'accept: */*' -H 'X-Vault-Token: '$VAULT_TOKEN -H 'X-Vault-Namespace:'"$ns" > "$response_file"

    # Extract any child namespaces from the response
    child_namespaces=$(cat $response_file | jq | grep "path" | cut -d'"' -f4)

    # Append the response to the output file
    if ! test -z "$child_namespaces"
    then
        echo "$child_namespaces" >> "$output_file"
    fi
    # Clean up the temporary file
    rm "$response_file"
    
    # Loop through each child namespace and recursively call the API
    for child_namespace in $child_namespaces; do
        call_api "${child_namespace}"
    done
}

# Call the API recursively, starting with the first Namespace
call_api "$1"
echo "All Namespaces listed in VaultNamespaceList.txt"