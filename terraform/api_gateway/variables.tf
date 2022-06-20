# Generic
variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

# Cloudwatch log group
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

# API Gateway
variable "name" {
  description = "The API Gateway name"
  type        = string
}

variable "protocol_type" {
  description = "The API Gateway protocol type"
  type        = string
}


