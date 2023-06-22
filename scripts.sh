#!/bin/bash

set -e

# Specify the directory where the JSON files are located
json_directory="$HOME/.aws/sso/cache"

# Check if the JSON files directory exists
if [ ! -d "$json_directory" ]; then
  echo "JSON files directory not found: $json_directory"
  exit 1
fi

# Check if the required parameters are provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <account-id> <role-name> <region>"
  exit 1
fi

# Assign the provided parameters to variables
account_id="$1"
role_name="$2"
region="$3"

# Find the JSON file that contains the "accessToken" attribute
json_file=$(grep -l '"accessToken"' "$json_directory"/*.json)

# Check if a matching file is found
if [ -z "$json_file" ]; then
  echo "No JSON file with 'accessToken' attribute found."
  exit 1
fi

# Extract the access token from the JSON file
access_token=$(jq -r '.accessToken' "$json_file")

# Run the AWS CLI command to get the temporary credentials
role_credentials=$(aws sso get-role-credentials --account-id "$account_id" 
--role-name "$role_name" --access-token "$access_token" --region 
"$region")

# Extract the individual credential values
access_key_id=$(echo "$role_credentials" | jq -r 
'.roleCredentials.accessKeyId')
secret_access_key=$(echo "$role_credentials" | jq -r 
'.roleCredentials.secretAccessKey')
session_token=$(echo "$role_credentials" | jq -r 
'.roleCredentials.sessionToken')

# Specify the path to the credentials file
credentials_file="$HOME/.aws/credentials"

# Append the temporary IAM Identity Center user credentials to the 
credentials file
echo "[default]" >> "$credentials_file"
echo "aws_access_key_id = $access_key_id" >> "$credentials_file"
echo "aws_secret_access_key = $secret_access_key" >> "$credentials_file"
echo "aws_session_token = $session_token" >> "$credentials_file"

# Set appropriate permissions for the credentials file
chmod 600 "$credentials_file"
