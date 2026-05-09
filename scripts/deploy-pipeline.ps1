param(
  [string]$StackName = "beginner-cicd-pipeline",
  [string]$Region = "us-east-1",
  [Parameter(Mandatory = $true)][string]$GitHubOwner,
  [Parameter(Mandatory = $true)][string]$GitHubRepo,
  [string]$GitHubBranch = "main",
  [Parameter(Mandatory = $true)][string]$ConnectionArn,
  [Parameter(Mandatory = $true)][string]$WebsiteBucketName,
  [Parameter(Mandatory = $true)][string]$CloudFrontDistributionId
)

$ErrorActionPreference = "Stop"

aws cloudformation deploy `
  --stack-name $StackName `
  --template-file "infra/pipeline.yml" `
  --region $Region `
  --capabilities CAPABILITY_NAMED_IAM `
  --parameter-overrides `
    GitHubOwner=$GitHubOwner `
    GitHubRepo=$GitHubRepo `
    GitHubBranch=$GitHubBranch `
    ConnectionArn=$ConnectionArn `
    WebsiteBucketName=$WebsiteBucketName `
    CloudFrontDistributionId=$CloudFrontDistributionId

aws cloudformation describe-stacks `
  --stack-name $StackName `
  --region $Region `
  --query "Stacks[0].Outputs" `
  --output table
