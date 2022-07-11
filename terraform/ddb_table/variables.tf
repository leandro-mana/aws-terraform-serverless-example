variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

variable "table_name" {
  description = "The Dynamo DB Table Name"
  type        = string
}

variable "billing_mode" {
  description = "The Billing Mode for the Dynamo DB Table"
  type        = string
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "The Dynamo DB Read Capacity"
  type        = number
}

variable "write_capacity" {
  description = "The Dynamo DB Write Capacity"
  type        = number
}

variable "hash_key" {
  description = "The Dynamo DB Hash Key"
  type        = string
}

variable "range_key" {
  description = "The Dynamo DB Range Key"
  type        = string
}

variable "attributes" {
  description = "List of objects containing the name and type values for the attribute"
  type        = list(map(string))
}