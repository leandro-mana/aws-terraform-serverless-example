# Generic
variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

# S3 Bucket
variable "bucket_name" {
  description = "The S3 Artifact Bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Bucket needs to be empty before destroy"
  type        = bool
  default     = true
}

# S3 Bucket ACL
variable "bucket_acl" {
  description = "The canned ACL to apply to the bucket"
  type        = string
  default     = "private"
}