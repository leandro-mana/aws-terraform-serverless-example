variable "api_gw_id" {
  description = "The API Gateway Id"
  type        = string
}

variable "integration_uri" {
  description = "The URI of the Lambda function for a Lambda proxy integration"
  type        = string
}

variable "integration_type" {
  description = "The integration HTTP type"
  type        = string
}

variable "integration_method" {
  description = "The integration HTTP method"
  type        = string
}