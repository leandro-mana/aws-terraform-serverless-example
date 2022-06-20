# Setup Terraform
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

# Providers
provider "aws" {
  region = var.aws_region
}

# Common Tags
locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
  }
}

###########
# Modules #
###########
# S3 Artifact
module "s3_artifact_bucket" {
  source      = "./s3_artifact_bucket"
  bucket_name = "${var.environment}-${var.project}-${var.aws_region}-artifacts"
  tags        = local.common_tags
}

# API Gateway
module "api_gateway" {
  source                = "./api_gateway"
  tags                  = local.common_tags
  name                  = "hello_app"
  protocol_type         = "HTTP"
  log_retention_in_days = var.log_retention_in_days
}

# hello_app
data "archive_file" "hello_app" {
  type        = "zip"
  source_dir  = "${path.module}/../src/hello_app"
  output_path = "${path.module}/../build/hello_app.zip"
}

module "lambda_hello_app" {
  source                = "./lambda"
  tags                  = local.common_tags
  artifact_source       = data.archive_file.hello_app.output_path
  artifact_bucket_id    = module.s3_artifact_bucket.id
  artifact_s3_key       = "hello_app/hello_app.zip"
  name                  = "hello_app"
  runtime               = "python3.8"
  handler               = "hello.lambda_handler"
  source_code_hash      = data.archive_file.hello_app.output_base64sha256
  policy_file_path      = "./iam_policies/hello_app.json"
  log_retention_in_days = var.log_retention_in_days
}

module "lambda_permission_hello_app" {
  source      = "./lambda_permission"
  lambda_name = module.lambda_hello_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = module.api_gateway.execution_arn
}

module "api_gw_stage_hello_app" {
  source           = "./api_gateway_stage"
  tags             = local.common_tags
  name             = "${module.lambda_hello_app.function_name}-stage"
  api_gw_id        = module.api_gateway.id
  cw_log_group_arn = module.api_gateway.cw_log_group_arn
}

module "api_gw_integration_hello_app" {
  source             = "./api_gateway_integration"
  api_gw_id          = module.api_gateway.id
  integration_uri    = module.lambda_hello_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_hello_app" {
  source    = "./api_gateway_route"
  api_gw_id = module.api_gateway.id
  route_key = "GET /hello"
  target    = "integrations/${module.api_gw_integration_hello_app.id}"
}