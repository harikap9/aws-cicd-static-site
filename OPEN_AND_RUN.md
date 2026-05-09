# Open And Run This Project Step By Step

You are on Windows, so use PowerShell.

This project has two parts:

1. Open the sample website on your computer.
2. Deploy the website to AWS using CI/CD.

Do not worry if you do not understand every word yet. Follow the steps in order.

## Part 1: Open The Website On Your Computer

This part does not need AWS.

### Step 1: Open The Project Folder

Open File Explorer and go to this folder:

```text
C:\Users\meeth\Documents\Codex\2026-05-08\i-dont-know-any-thing-help
```

### Step 2: Open The Website File

Open this folder:

```text
app
```

Double-click this file:

```text
index.html
```

Your browser should open the demo website.

If it opens, good. That is the website your CI/CD pipeline will deploy later.

## Part 2: Install The Tools

You need two tools before AWS deployment can work.

### Step 1: Install Git

Download and install Git:

```text
https://git-scm.com/downloads
```

During installation, keep clicking Next with the default options.

### Step 2: Install AWS CLI

Download and install AWS CLI:

```text
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```

Choose Windows installer.

### Step 3: Restart PowerShell

Close PowerShell.

Open PowerShell again.

### Step 4: Check If Tools Work

Run:

```powershell
git --version
```

Then run:

```powershell
aws --version
```

If both show version numbers, you are ready.

## Part 3: Open PowerShell In The Project Folder

Open PowerShell.

Run this command:

```powershell
cd "C:\Users\meeth\Documents\Codex\2026-05-08\i-dont-know-any-thing-help"
```

Now run:

```powershell
dir
```

You should see files like:

```text
README.md
BEGIN_HERE.md
OPEN_AND_RUN.md
buildspec.yml
app
infra
scripts
```

## Part 4: Connect AWS CLI To Your AWS Account

Run:

```powershell
aws configure
```

It will ask four questions.

Use your AWS access key:

```text
AWS Access Key ID: paste your key
AWS Secret Access Key: paste your secret
Default region name: us-east-1
Default output format: json
```

If you do not have an access key, create one in AWS:

```text
AWS Console -> IAM -> Users -> your user -> Security credentials -> Create access key
```

For a school/demo task, your IAM user needs permission to create:

```text
S3
CloudFront
CodePipeline
CodeBuild
IAM roles
CloudFormation
CodeStar Connections
```

## Part 5: Create A GitHub Repository

Go to GitHub and create a new repository.

Repository name:

```text
aws-cicd-static-site
```

Do not add README from GitHub. This folder already has one.

## Part 6: Upload This Project To GitHub

In PowerShell, inside the project folder, run these one by one:

```powershell
git init
```

```powershell
git add .
```

```powershell
git commit -m "Add AWS CI CD project"
```

```powershell
git branch -M main
```

Now replace `YOUR_GITHUB_USERNAME` below with your real GitHub username:

```powershell
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/aws-cicd-static-site.git
```

Then run:

```powershell
git push -u origin main
```

If GitHub asks you to log in, follow the browser login.

## Part 7: Create GitHub Connection In AWS

Open AWS Console in your browser.

Search:

```text
Developer Tools
```

Then go to:

```text
Settings -> Connections -> Create connection
```

Choose:

```text
GitHub
```

Connection name:

```text
github-cicd-connection
```

Click connect/authorize.

After it is created, copy the connection ARN.

It looks similar to:

```text
arn:aws:codestar-connections:us-east-1:123456789012:connection/abc123
```

Keep it. You need it soon.

## Part 8: Create S3 And CloudFront

In PowerShell, run:

```powershell
.\scripts\deploy-infra.ps1 -StackName beginner-static-site -Region us-east-1
```

Wait. This can take several minutes.

At the end, copy these three values:

```text
WebsiteBucketName
CloudFrontDistributionId
CloudFrontDomainName
```

## Part 9: Create The CI/CD Pipeline

Replace the values in this command.

Important:

- Replace `YOUR_GITHUB_USERNAME`
- Replace `YOUR_CONNECTION_ARN`
- Replace `YOUR_WEBSITE_BUCKET_NAME`
- Replace `YOUR_CLOUDFRONT_DISTRIBUTION_ID`

Then run:

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

Wait until it finishes.

## Part 10: Run The Pipeline

Open AWS Console.

Search:

```text
CodePipeline
```

Open:

```text
beginner-cicd-pipeline
```

Click:

```text
Release change
```

Wait until everything becomes green.

## Part 11: Open Your Live Website

Open the `CloudFrontDomainName` URL from Part 8.

Example:

```text
https://d123example.cloudfront.net
```

That is your deployed website.

## Part 12: Prove CI/CD Works

Open this file:

```text
app\index.html
```

Change some text.

Save the file.

Then run:

```powershell
git add .
```

```powershell
git commit -m "Update website text"
```

```powershell
git push
```

Now go to AWS CodePipeline. It should run automatically.

After it turns green, refresh your CloudFront website.

## If Something Goes Wrong

If `git` is not recognized:

```text
Git is not installed, or PowerShell was opened before installing Git.
```

Fix:

```text
Install Git, close PowerShell, open PowerShell again.
```

If `aws` is not recognized:

```text
AWS CLI is not installed, or PowerShell was opened before installing AWS CLI.
```

Fix:

```text
Install AWS CLI, close PowerShell, open PowerShell again.
```

If AWS says access denied:

```text
Your AWS user does not have enough permissions.
```

Fix:

```text
Use an admin AWS user for this learning task, or ask your teacher/admin for permissions.
```

If CodePipeline source fails:

```text
The GitHub connection or repository name is wrong.
```

Fix:

```text
Check the connection ARN, GitHub username, repository name, and branch name.
```

## What To Show Your Teacher

Show these:

1. GitHub repository with this code
2. AWS CloudFormation stacks
3. AWS CodePipeline with green stages
4. Live CloudFront website URL
5. `buildspec.yml` file showing the deploy commands

