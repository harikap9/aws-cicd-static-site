param(
  [string]$StackName = "beginner-static-site",
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

aws cloudformation deploy `
  --stack-name $StackName `
  --template-file "infra/static-site.yml" `
  --region $Region

aws cloudformation describe-stacks `
  --stack-name $StackName `
  --region $Region `
  --query "Stacks[0].Outputs" `
  --output table
