param(
  [Parameter(Mandatory = $true)][string]$BucketName,
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

aws s3 rm "s3://$BucketName" --recursive --region $Region
