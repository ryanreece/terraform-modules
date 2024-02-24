variable "bucket_name" {
  type    = string
  default = ""
}

variable "aws_account_number" {
  type    = string
  default = ""
}

variable "enable_s3_logs" {
  type    = bool
  default = false
}

variable "s3_logs_bucket_id" {
  type    = string
  default = ""
}

variable "enable_s3_event_notifications" {
  type    = bool
  default = false
}

variable "enable_s3_bucket_lifecycle_configuration" {
  type    = bool
  default = false
}

variable "s3_event_notifications_arn" {
  type    = string
  default = ""
}

variable "bucket_acl" {
  type    = string
  default = "private"
}

variable "bucket_ownership_preference" {
  type    = string
  default = "BucketOwnerPreferred"
}

variable "include_cloudfront_service_principal" {
  type    = bool
  default = false
}

variable "enable_allow_access_logs" {
  type    = bool
  default = false
}

variable "cloudfront_arn" {
  type    = string
  default = ""
}
