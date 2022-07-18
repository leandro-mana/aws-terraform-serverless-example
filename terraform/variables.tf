# Globals
variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "owner" {
  description = "The owner of the project"
  type        = string
}

variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

# Lambda PowerTools Provided Layer
variable "aws_provided_layer_account_id" {
  description = "AWS Provided Account Id for Lambda Power Tools Layer"
  type        = string
  default     = "017000801446"
}

variable "aws_provided_layer_name" {
  description = "AWS Provided Layer Name for Lambda Power Tools Layer"
  type        = string
  default     = "AWSLambdaPowertoolsPython"
}

variable "aws_provided_layer_version" {
  description = "AWS Provided Layer Version for Lambda Power Tools Layer"
  type        = string
  default     = "22"
}

# Cloudwatch log group
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

# Movies App
variable "movies_app_ddb_table" {
  description = "The Dynamo DB Table Name"
  type        = string
}

variable "movies_app_ddb_billing_mode" {
  description = "The Billing Mode for the Dynamo DB Table"
  type        = string
  default     = "PROVISIONED"
}

variable "movies_app_ddb_read_capacity" {
  description = "The Dynamo DB Read Capacity"
  type        = number
}

variable "movies_app_ddb_write_capacity" {
  description = "The Dynamo DB Write Capacity"
  type        = number
}

variable "movies_app_ddb_hash_key" {
  description = "The Dynamo DB Hash Key"
  type        = string
}

variable "movies_app_ddb_range_key" {
  description = "The Dynamo DB Range Key"
  type        = string
}