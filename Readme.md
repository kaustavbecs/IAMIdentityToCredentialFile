# Purpose
Utilties such as S3Fuse does not work properly with AWS SSO (IAM Identity Center) temporary crendentials. This tool will provide a workaround to mount S3 to a filesystem using S3Fuse for IAM Identity center users

# Prerequisites
1. AWS CLI V2 installed
2. jq installed
3. curl installed
4. s3fs installed
5. s3 bucket created

# Usage
1. Go to your $Home/.aws directory from the terminal

    ```cd $HOME/.aws```
1. Download the script to your $Home/.aws directory

    ```curl -O https://raw.githubusercontent.com/kaustavbecs/IAMIdentityToCredentialFile/main/script.sh```
2. Run the command to add the execute permission: 

    ```chmod +x script.sh```

3. Configure SSO with the IAM account center and details

    ```aws configure sso```

4. Execute the script: 

    ```/home/ubuntu/.aws/script.sh <AccountID> <"Role"> <"Region">```

5. Create a directory to mount S3

    ```mkdir /mnt/s3mnt```

6. Use S3FS to mount

    ```s3fs <bucket> /mnt/s3mnt```

7. Verify the mount

    ```ls /mnt/s3mnt```

