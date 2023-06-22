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

# Find the two most recent JSON files in the directory
json_files=$(ls -t "$json_directory"/*.json | head -n 2)

# Check if matching files are found
if [ -z "$json_files" ]; then
  echo "No JSON files found."
  exit 1
fi

# Extract the access token from the JSON files
access_token=""
for json_file in $json_files; do
  token=$(jq -r '.accessToken' "$json_file")
  if [ "$token" != "null" ]; then
    access_token="$token"
    break
  fi
done

# Check if access token is found
if [ -z "$access_token" ]; then
  echo "No access token found in the JSON files."
  exit 1
fi

# Run the AWS CLI command to get the temporary credentials
role_credentials=$(aws sso get-role-credentials --account-id "$account_id" --role-name "$role_name" --access-token "$access_token" --region "$region")

# Extract the individual credential values
access_key_id=$(echo "$role_credentials" | jq -r '.roleCredentials.accessKeyId')
secret_access_key=$(echo "$role_credentials" | jq -r '.roleCredentials.secretAccessKey')
session_token=$(echo "$role_credentials" | jq -r '.roleCredentials.sessionToken')

# Specify the path to the credentials file
credentials_file="$HOME/.aws/credentials"

# Clear the contents of the existing credentials file
> "$credentials_file"

# Append the temporary IAM Identity Center user credentials to the credentials file
echo "[default]" >> "$credentials_file"
echo "aws_access_key_id = $access_key_id" >> "$credentials_file"
echo "aws_secret_access_key = $secret_access_key" >> "$credentials_file"
echo "aws_session_token = $session_token" >> "$credentials_file"

# Set appropriate permissions for the credentials file
chmod 600 "$credentials_file"
