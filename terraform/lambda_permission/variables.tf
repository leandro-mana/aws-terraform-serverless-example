variable "lambda_name" {
  description = "The Lambda name"
  type        = string
}

variable "principal" {
  description = "The principal resource that is getting the permission"
  type        = string
}

variable "source_arn" {
  description = "The source ARN for the permission"
  type        = string
}