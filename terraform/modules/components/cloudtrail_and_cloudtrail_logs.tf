#############################################################################################################################################
# default cloudtrail logs and S3 bucket
#############################################################################################################################################
resource "aws_s3_bucket" "S3-CloudTrail" {
  #provider          = "aws.Requester_Lon"
  bucket = "${var.CloudTrail-S3-Name}"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${var.CloudTrail-S3-Name}"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.CloudTrail-S3-Name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.CloudTrail-S3-Name}/AWSLogs/${var.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },   
        {
            "Sid": "SSL access only",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::${var.CloudTrail-S3-Name}/*",
            "Condition": {
              "Bool": {
                  "aws:SecureTransport": "false"
              }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "example" {
  #provider          = "aws.Requester_Lon"
  bucket = "${aws_s3_bucket.S3-CloudTrail.id}"

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
/*
resource  "aws_kms_key" "CloudTrailLogs" {
  enable_key_rotation           = true

}

resource "aws_kms_grant" "key-usage-grant" {
  name              = "my-grant"
  key_id            = aws_kms_key.CloudTrailLogs.key_id
  grantee_principal = aws_iam_role.cloudtrail_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}
*/
resource "aws_cloudtrail" "foobar" {
  #provider          = "aws.Requester_Lon"
  name = "${var.CloudTrail-Trail}"
  s3_bucket_name = "${aws_s3_bucket.S3-CloudTrail.id}"
  s3_key_prefix = ""
  include_global_service_events = true
  is_multi_region_trail = true
  enable_log_file_validation = true
  #kms_key_id                    = "${aws_kms_key.CloudTrailLogs.arn}"
  cloud_watch_logs_role_arn = "${aws_iam_role.cloudtrail_role.arn}"
  cloud_watch_logs_group_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.cloudtrail_log_group_name}:*"
  depends_on = [aws_s3_bucket.S3-CloudTrail]
}

