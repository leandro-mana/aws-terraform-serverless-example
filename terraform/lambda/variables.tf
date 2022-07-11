# Generic
variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

# S3 Artifact
variable "artifact_source" {
  description = "The path for the Lambda artifact"
  type        = string

}

variable "artifact_bucket_id" {
  description = "The S3 Bucket Id for Lambda artifacts"
  type        = string
}

variable "artifact_s3_key" {
  description = "The S3 Bucket key for the Lambda artifact"
  type        = string
}

# IAM
variable "policy_file_path" {
  description = "The JSON file path for the policy document"
  type        = string
  default     = ""
}

variable "iam_policy_json_document" {
  description = "The JSON policy document when policy_file_path is null"
  type        = string
  default     = ""
}

# Cloudwatch log group
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

# Lambda
variable "name" {
  description = "The Lambda name"
  type        = string
}

variable "runtime" {
  description = "The Lambda runtime name"
  type        = string
}

variable "handler" {
  description = "The Lambda handler"
  type        = string
}

variable "source_code_hash" {
  description = "The Lambda source code hash"
  type        = string
}

variable "environment_vars" {
  description = "The Lambda Environmental variables"
  type        = list(any)
}