# Start Here

Use this file when you are ready to execute the project.

## What This Project Does

This project creates a real AWS CI/CD pipeline.

You push code to GitHub. AWS CodePipeline notices the change. AWS CodeBuild ships the files in `app/` to S3. CloudFront serves the public website.

## First Install These

Install these on your computer:

1. AWS CLI
2. Git

Then confirm they work:

```powershell
aws --version
git --version
```

## Execution Order

Run the project in this exact order.

### 1. Configure AWS

```powershell
aws configure
```

Use region:

```text
us-east-1
```

### 2. Push This Folder To GitHub

```powershell
git init
git add .
git commit -m "Add AWS CI/CD pipeline project"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/aws-cicd-static-site.git
git push -u origin main
```

### 3. Create AWS GitHub Connection

In AWS Console:

```text
Developer Tools -> Settings -> Connections -> Create connection -> GitHub
```

Copy the connection ARN.

### 4. Create S3 And CloudFront

```powershell
.\scripts\deploy-infra.ps1 -StackName beginner-static-site -Region us-east-1
```

Copy these output values:

```text
WebsiteBucketName
CloudFrontDistributionId
CloudFrontDomainName
```

### 5. Create CodePipeline

```powershell
.\scripts\deploy-pipeline.ps1 `
  -StackName beginner-cicd-pipeline `
  -Region us-east-1 `
  -GitHubOwner YOUR_GITHUB_USERNAME `
  -GitHubRepo aws-cicd-static-site `
  -GitHubBranch main `
  -ConnectionArn "YOUR_CONNECTION_ARN" `
  -WebsiteBucketName "YOUR_WEBSITE_BUCKET_NAME" `
  -CloudFrontDistributionId "YOUR_CLOUDFRONT_DISTRIBUTION_ID"
```

### 6. Run Pipeline

In AWS Console:

```text
CodePipeline -> beginner-cicd-pipeline -> Release change
```

Wait until the pipeline turns green.

### 7. Open Website

Open the `CloudFrontDomainName` URL from step 4.

### 8. Test CI/CD

Change text inside:

```text
app/index.html
```

Then push:

```powershell
git add .
git commit -m "Update website"
git push
```

AWS should automatically deploy the new version.

## Main Files To Mention In Your Assignment

- `infra/static-site.yml`: creates S3 and CloudFront
- `infra/pipeline.yml`: creates CodePipeline and CodeBuild
- `buildspec.yml`: contains the shipping commands
- `scripts/deploy-infra.ps1`: deploys website infrastructure
- `scripts/deploy-pipeline.ps1`: deploys CI/CD pipeline
- `app/`: website files that get shipped

## The Most Important Shipping Command

```bash
aws s3 sync app/ "s3://$WEBSITE_BUCKET_NAME" --delete
```

That command uploads your website files to AWS.
