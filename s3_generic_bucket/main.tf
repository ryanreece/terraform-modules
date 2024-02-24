resource "aws_s3_bucket" "s3_generic_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "s3_generic_bucket" {
  bucket = aws_s3_bucket.s3_generic_bucket.id

  rule {
    object_ownership = var.bucket_ownership_preference
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_generic_bucket" {
  bucket = aws_s3_bucket.s3_generic_bucket.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_generic_bucket" {
  bucket = aws_s3_bucket.s3_generic_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "s3_generic_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_generic_bucket,
    aws_s3_bucket_public_access_block.s3_generic_bucket
  ]

  bucket = aws_s3_bucket.s3_generic_bucket.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_logging" "s3_generic_bucket" {
  count  = var.enable_s3_logs ? 1 : 0
  bucket = aws_s3_bucket.s3_generic_bucket.id

  target_bucket = var.s3_logs_bucket_id
  target_prefix = "${aws_s3_bucket.s3_generic_bucket.id}-log/"
}

resource "aws_s3_bucket_notification" "s3_generic_bucket" {
  count  = var.enable_s3_event_notifications ? 1 : 0
  bucket = aws_s3_bucket.s3_generic_bucket.id

  topic {
    topic_arn = var.s3_event_notifications_arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket_versioning" "s3_generic_bucket" {
  bucket = aws_s3_bucket.s3_generic_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_generic_bucket" {
  count      = var.enable_s3_bucket_lifecycle_configuration ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.s3_generic_bucket]

  bucket = aws_s3_bucket.s3_generic_bucket.id

  rule {
    id = "transition-noncurrent-objects"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days           = 730
      newer_noncurrent_versions = 5
    }

    noncurrent_version_transition {
      noncurrent_days = 180
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 365
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

data "aws_iam_policy_document" "s3_generic_bucket" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.s3_generic_bucket.arn,
      "${aws_s3_bucket.s3_generic_bucket.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:secureTransport"

      values = ["false"]
    }
  }

  dynamic "statement" {
    for_each = var.include_cloudfront_service_principal ? [1] : []
    content {
      sid       = "AllowCloudFrontServicePrincipal"
      actions   = ["s3:GetObject"]
      resources = ["${aws_s3_bucket.s3_generic_bucket.arn}/*"]

      principals {
        type        = "Service"
        identifiers = ["cloudfront.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "AWS:SourceArn"

        values = [
          var.cloudfront_arn
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_allow_access_logs ? [1] : []
    content {
      sid       = "AllowAccessLogs"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.s3_generic_bucket.arn}/*"]

      principals {
        type        = "Service"
        identifiers = ["logging.s3.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"

        values = [
          var.aws_account_id
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_allow_access_logs ? [1] : []
    content {
      sid       = "AllowGetBucketAcl"
      actions   = ["s3:GetBucketAcl"]
      resources = ["${aws_s3_bucket.s3_generic_bucket.arn}"]

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"

        values = [
          var.aws_account_id
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_allow_access_logs ? [1] : []
    content {
      sid       = "AllowGetObjectAcl"
      actions   = ["s3:GetObjectAcl", "s3:PutObject"]
      resources = ["${aws_s3_bucket.s3_generic_bucket.arn}/*"]

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"

        values = [
          var.aws_account_id
        ]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "s3_generic_bucket" {
  depends_on = [aws_s3_bucket.s3_generic_bucket]
  bucket     = aws_s3_bucket.s3_generic_bucket.id
  policy     = data.aws_iam_policy_document.s3_generic_bucket.json
}
