variable "bucket_name" {
  description = "The name of the S3 bucket to be created. This name must be unique across all existing bucket names in AWS."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "The AWS account id where the resources will be deployed. This is used for constructing ARNs and for identifying the correct account in policies."
  type        = number
  default     = 0
}

variable "enable_s3_logs" {
  description = "A boolean flag to enable or disable logging for the S3 bucket. When enabled, access logs for the bucket will be collected."
  type        = bool
  default     = false
}

variable "s3_logs_bucket_id" {
  description = "The ID of the S3 bucket where access logs should be stored. This is required if 'enable_s3_logs' is set to true."
  type        = string
  default     = ""
}

variable "enable_s3_event_notifications" {
  description = "A boolean flag to enable or disable event notifications for the S3 bucket. This allows you to receive notifications for specified S3 bucket events."
  type        = bool
  default     = false
}

variable "enable_s3_bucket_lifecycle_configuration" {
  description = "A boolean flag to enable or disable lifecycle configuration on the S3 bucket. This is used to automate moving or deleting objects after a certain period of time."
  type        = bool
  default     = false
}

variable "s3_event_notifications_arn" {
  description = "The ARN (Amazon Resource Name) of the destination (e.g., SQS, SNS, Lambda) for S3 bucket event notifications. Required if 'enable_s3_event_notifications' is true."
  type        = string
  default     = ""
}

variable "bucket_acl" {
  description = "The Access Control List (ACL) policy for the S3 bucket. Defines who can access the bucket and what actions they can perform. Common values are 'private', 'public-read', etc."
  type        = string
  default     = "private"
}

variable "bucket_ownership_preference" {
  description = "Specifies the ownership preference for objects in the S3 bucket. This affects how access is evaluated when objects are accessed by AWS services. 'BucketOwnerPreferred' or 'ObjectWriter'."
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "include_cloudfront_service_principal" {
  description = "A boolean flag to include the CloudFront service principal in the bucket policy. This is necessary if you're using CloudFront to distribute content in the S3 bucket."
  type        = bool
  default     = false
}

variable "enable_allow_access_logs" {
  description = "A boolean flag to enable permissions for allowing access logs. This is typically used in conjunction with 'enable_s3_logs' to permit log delivery to the specified logging bucket."
  type        = bool
  default     = false
}

variable "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution associated with the S3 bucket. Required if 'include_cloudfront_service_principal' is set to true to correctly set up permissions."
  type        = string
  default     = ""
}

