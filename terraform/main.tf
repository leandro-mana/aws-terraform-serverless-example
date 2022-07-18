# Modular Infrastructure

######################
# S3 Artifact Bucket #
######################
module "s3_artifact_bucket" {
  source      = "./s3_artifact_bucket"
  bucket_name = "${var.environment}-${var.project}-${var.aws_region}-artifacts"
  tags        = local.common_tags
}

###############
# API Gateway #
###############
module "api_gateway" {
  source                = "./api_gateway"
  tags                  = local.common_tags
  name                  = "hello_app"
  protocol_type         = "HTTP"
  log_retention_in_days = var.log_retention_in_days
}

#############
# hello_app #
#############
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
  policy_file_path      = "./iam_policies/lambda_generic.json"
  log_retention_in_days = var.log_retention_in_days
  layers = [
    "arn:aws:lambda:${var.aws_region}:${var.aws_provided_layer_account_id}:layer:${var.aws_provided_layer_name}:${var.aws_provided_layer_version}"
  ]  
  environment_vars      = []
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

##############
# Movies App #
##############
module "ddb_table_movies" {
  source         = "./ddb_table"
  tags           = local.common_tags
  table_name     = "${var.environment}-${var.movies_app_ddb_table}"
  billing_mode   = var.movies_app_ddb_billing_mode
  read_capacity  = var.movies_app_ddb_read_capacity
  write_capacity = var.movies_app_ddb_write_capacity
  hash_key       = var.movies_app_ddb_hash_key
  range_key      = var.movies_app_ddb_range_key
  attributes = [
    { name = "year", type = "N" },
    { name = "title", type = "S" }
  ]
}

data "aws_iam_policy_document" "movies_app" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:*:*:table/${module.ddb_table_movies.id}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "archive_file" "movies_app" {
  type        = "zip"
  source_dir  = "${path.module}/../src/movies_app"
  output_path = "${path.module}/../build/movies_app.zip"
}

module "lambda_movies_app" {
  source                   = "./lambda"
  tags                     = local.common_tags
  artifact_source          = data.archive_file.movies_app.output_path
  artifact_bucket_id       = module.s3_artifact_bucket.id
  artifact_s3_key          = "movies_app/movies_app.zip"
  name                     = "movies_app"
  runtime                  = "python3.8"
  handler                  = "movies.lambda_handler"
  source_code_hash         = data.archive_file.movies_app.output_base64sha256
  iam_policy_json_document = data.aws_iam_policy_document.movies_app.json
  log_retention_in_days    = var.log_retention_in_days
  layers = [
    "arn:aws:lambda:${var.aws_region}:${var.aws_provided_layer_account_id}:layer:${var.aws_provided_layer_name}:${var.aws_provided_layer_version}"
  ]  
  environment_vars = [
    {
      DDB_TABLE = "${var.environment}-${var.movies_app_ddb_table}"
    }
  ]
}

module "lambda_permission_movies_app" {
  source      = "./lambda_permission"
  lambda_name = module.lambda_movies_app.function_name
  principal   = "apigateway.amazonaws.com"
  source_arn  = module.api_gateway.execution_arn
}

module "api_gw_stage_movies_app" {
  source           = "./api_gateway_stage"
  tags             = local.common_tags
  name             = "${module.lambda_movies_app.function_name}-stage"
  api_gw_id        = module.api_gateway.id
  cw_log_group_arn = module.api_gateway.cw_log_group_arn
}

module "api_gw_integration_movies_app" {
  source             = "./api_gateway_integration"
  api_gw_id          = module.api_gateway.id
  integration_uri    = module.lambda_movies_app.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

module "api_gw_route_movies_app" {
  source    = "./api_gateway_route"
  api_gw_id = module.api_gateway.id
  route_key = "POST /movies"
  target    = "integrations/${module.api_gw_integration_movies_app.id}"
}
