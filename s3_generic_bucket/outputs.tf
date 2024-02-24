output "s3_bucket_details" {
  value = {
    arn                         = aws_s3_bucket.s3_generic_bucket.arn
    id                          = aws_s3_bucket.s3_generic_bucket.id
    bucket_domain_name          = aws_s3_bucket.s3_generic_bucket.bucket_domain_name
    bucket_regional_domain_name = aws_s3_bucket.s3_generic_bucket.bucket_regional_domain_name
  }
}
