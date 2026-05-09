# Beginner AWS CI/CD Pipeline

This project gives you a complete end-to-end CI/CD pipeline using AWS.

What it deploys:

- A simple static website from the `app/` folder
- An S3 bucket for website files
- A CloudFront distribution for public access
- AWS CodePipeline for CI/CD
- AWS CodeBuild for build and deployment steps

When you push code to GitHub, AWS automatically builds and ships the website to S3, then clears the CloudFront cache.

## Architecture

```text
GitHub repository
       |
       v
AWS CodePipeline
       |
       v
AWS CodeBuild
       |
       v
S3 bucket + CloudFront
       |
       v
Public website URL
```

## Files Included

```text
app/
  index.html
  styles.css
  app.js

infra/
  static-site.yml
  pipeline.yml

scripts/
  deploy-infra.ps1
  deploy-pipeline.ps1
  empty-bucket.ps1

buildspec.yml
README.md
```

## What You Need Before Starting

Create these accounts/tools first:

1. AWS account
2. GitHub account
3. Git installed on your computer
4. AWS CLI installed on your computer
5. A terminal such as PowerShell

Install links:

- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Git: https://git-scm.com/downloads

## Step 1: Configure AWS CLI

Open PowerShell and run:

```powershell
aws configure
```

Enter:

- AWS Access Key ID
- AWS Secret Access Key
- Default region, for example `us-east-1`
- Default output format: `json`

For a beginner task, use region:

```text
us-east-1
```

## Step 2: Create a GitHub Repository

1. Go to GitHub.
2. Create a new repository.
3. Example repository name:

```text
aws-cicd-static-site
```

4. Push this project to GitHub:

```powershell
git init
git add .
git commit -m "Add AWS CI/CD static site"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/aws-cicd-static-site.git
git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME` with your real GitHub username.

## Step 3: Create GitHub Connection in AWS

AWS CodePipeline needs permission to read your GitHub repo.

1. Open AWS Console.
2. Search for `Developer Tools`.
3. Open `Settings`.
4. Open `Connections`.
5. Click `Create connection`.
6. Choose `GitHub`.
7. Name it:

```text
github-cicd-connection
```

8. Click `Connect to GitHub`.
9. Authorize AWS.
10. After it is created, copy the connection ARN.

It will look like:

```text
arn:aws:codestar-connections:us-east-1:123456789012:connection/abc12345-....
```

Save this ARN. You need it in Step 5.

## Step 4: Deploy Website Infrastructure

This creates:

- S3 bucket
- CloudFront distribution
- CloudFront origin access control

Run:

```powershell
.\scripts\deploy-infra.ps1 -StackName beginner-static-site -Region us-east-1
```

After it finishes, it prints:

- Website bucket name
- CloudFront distribution ID
- CloudFront website URL

Keep those values.

## Step 5: Deploy CI/CD Pipeline

Run this command, replacing the placeholder values:

```powershell
.\scripts\deploy-pipeline.ps1 `
  -StackName beginner-cicd-pipeline `
  -Region us-east-1 `
  -GitHubOwner YOUR_GITHUB_USERNAME `
  -GitHubRepo aws-cicd-static-site `
  -GitHubBranch main `
  -ConnectionArn "PASTE_YOUR_CONNECTION_ARN_HERE" `
  -WebsiteBucketName "PASTE_WEBSITE_BUCKET_NAME_HERE" `
  -CloudFrontDistributionId "PASTE_CLOUDFRONT_DISTRIBUTION_ID_HERE"
```

PowerShell uses the backtick character ``` ` ``` for line continuation. You can also put the whole command on one line.

## Step 6: Run the Pipeline

1. Open AWS Console.
2. Search for `CodePipeline`.
3. Open the pipeline named:

```text
beginner-cicd-pipeline
```

4. Click `Release change`.
5. Wait for all stages to become green.

The stages are:

- Source: pulls code from GitHub
- BuildAndDeploy: ships files to S3 and invalidates CloudFront

## Step 7: Open Your Website

After the pipeline succeeds, open the CloudFront URL from Step 4.

It looks like:

```text
https://d123example.cloudfront.net
```

## Step 8: Test Automatic CI/CD

Edit this file:

```text
app/index.html
```

Change some text, then run:

```powershell
git add .
git commit -m "Update homepage text"
git push
```

Now go back to AWS CodePipeline. A new pipeline run should start automatically.

When it finishes, refresh your CloudFront website URL.

## How The Build Ships Files

The shipping logic is in `buildspec.yml`.

Important commands:

```bash
aws s3 sync app/ "s3://$WEBSITE_BUCKET_NAME" --delete
aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" --paths "/*"
```

Meaning:

- `aws s3 sync` uploads the website files.
- `--delete` removes files from S3 that no longer exist in `app/`.
- `create-invalidation` tells CloudFront to stop serving old cached files.

## Clean Up To Avoid AWS Charges

CloudFront and S3 can cost money. When you are done, delete the resources.

First empty the S3 buckets:

```powershell
.\scripts\empty-bucket.ps1 -BucketName YOUR_WEBSITE_BUCKET_NAME
```

Then delete stacks:

```powershell
aws cloudformation delete-stack --stack-name beginner-cicd-pipeline --region us-east-1
aws cloudformation delete-stack --stack-name beginner-static-site --region us-east-1
```

You may also need to empty and delete the artifact bucket created by the pipeline stack.

## Troubleshooting

If the pipeline fails at Source:

- Check the GitHub connection status in AWS Developer Tools.
- Make sure the repo owner, repo name, and branch are correct.

If the pipeline fails at BuildAndDeploy:

- Open CodeBuild logs.
- Check that `WEBSITE_BUCKET_NAME` and `CLOUDFRONT_DISTRIBUTION_ID` are correct.

If the website still shows old content:

- Wait 1-3 minutes for CloudFront invalidation.
- Hard refresh your browser.

## What To Say In Your Submission

You can describe the project like this:

> I created an AWS CI/CD pipeline using CodePipeline and CodeBuild. The source code is stored in GitHub. On every push to the main branch, CodePipeline starts automatically, CodeBuild uploads the latest website files to S3, and CloudFront cache is invalidated so users receive the newest version. Infrastructure is created with CloudFormation templates, and deployment scripts are included for repeatable setup.
