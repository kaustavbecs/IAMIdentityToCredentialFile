# S3 Fuse with AWS IAM Identity Center (SSO)

Utilities such as S3Fuse may not work properly with AWS AWS IAM Identity Center (SSO) temporary credentials. So, this tool provides a workaround to mount S3 to a filesystem using S3Fuse for AWS IAM Identity Center (SSO) users. 

## Prerequisites

1. AWS CLI v2 installed
2. `jq` package installed
3. `curl` package installed
4. `s3fs` package installed
5. S3 bucket created

## Usage

1. Open a terminal.

2. Navigate to your `$HOME/.aws` directory by running the following command:

    ```shell
    cd $HOME/.aws
    ```

3. (Optional) If you have an existing `credentials` file in the `$HOME/.aws` directory, consider creating a backup before proceeding. You can use the following command to make a backup:

    ```shell
    mv credentials credentials_backup
    ```

   Note: This step is optional but recommended to avoid any conflicts or issues with the new credentials.

4. Download the script to your `$HOME/.aws` directory by running the following command:

    ```shell
    curl -O https://raw.githubusercontent.com/kaustavbecs/IAMIdentityToCredentialFile/main/script.sh
    ```

5. Add execute permission to the script by running the following command:

    ```shell
    chmod +x script.sh
    ```

6. Configure AWS SSO with the IAM Account Center and provide the necessary details by running the following command:

    ```shell
    aws configure sso
    ```


7. Execute the script by running the following command, replacing `<AccountID>`, `<Role>`, and `<Region>` with your specific values:

    ```shell
    ./script.sh <AccountID> "<Role>" "<Region>"
    ```

   The script will generate a new `credentials` file with the IAM Identity Center credentials. The `<AccountID>` is the AWS account ID associated with your IAM Identity Center user. The `<Role>` is the name of the role you want to assume. The `<Region>` is the AWS region where the role is located.

   For example:

   ```shell
   ./script.sh 123456789012 "MyRole" "us-west-2"
    ```
8. Create a directory to mount S3 by running the following command:

    ```shell
    mkdir $HOME/s3mnt
    ```

9. Use S3FS to mount the S3 bucket by running the following command, replacing `<bucket>` with your S3 bucket name:

    ```shell
    s3fs <bucket> $HOME/s3mnt
    ```

10. Verify the mount by listing the contents of the mount directory:

    ```shell
    ls $HOME/s3mnt
    ```

    You should see the files and directories from your S3 bucket listed.

## Disclaimer

1. This tool is provided as-is without any warranties or guarantees. Use it at your own risk.
2. Ensure that you have the necessary permissions and access rights to use AWS SSO and access the specified AWS resources.
3. Make sure to follow the AWS Terms of Service and guidelines while using this tool.
4. Review the code and understand its implications before running it in your environment.
5. Backup any important files or credentials before making any changes.
