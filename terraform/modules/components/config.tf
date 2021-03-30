#############################################################################################################################################
# Config central S3 bucket setup
#############################################################################################################################################

#creates configureation recorder (not enabled by default)
resource "aws_config_configuration_recorder" "foo" {
  name     = "default"
  role_arn = "${aws_iam_role.config_iam_role.arn}"
}

#enables configuration recorder
resource "aws_config_configuration_recorder_status" "aws_config_configuration_recorder_status" {
  name       = "${aws_config_configuration_recorder.foo.name}"
  is_enabled = true
  #depends_on = ["aws_config_delivery_channel.foo"]
}
#creates configs delivery channel (this replicates the current delivery channel with resource snapshots every 24 hour)
resource "aws_config_delivery_channel" "foo" {
  name           = "default"
  s3_bucket_name = "${data.aws_s3_bucket.configs3bucket.bucket}"
  depends_on     = ["aws_config_configuration_recorder.foo"]
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

resource "aws_s3_bucket" "configs3bucket" {
  bucket   = "var.configbucketname"


  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 0
    enabled                                = true
    id                                     = "delete after 13 months"
    tags = {
      "environment"  = "${var.Environment}"
      "pillar"       = "${var.Pillar}"
      "product"      = "${var.Product}"
      "product:type" = "infrastructure"
    }

    expiration {
      days                         = 400
      expired_object_delete_marker = false
    }

    noncurrent_version_expiration {
      days = 400
    }

  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    id          = "01bd0526a3b2c7f0e0192719cb894912a721e6c6dd0c545882a04a2043c9745c"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  grant {
    id          = "0fbf40e261233eabe6b2b58762dd73f5075b6ae6d1e0f2eed108d9612d19bbd0"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "1e46916199073478c297755b784ba2f6efec32566dbeead8edad37f9e88d1631"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "2b6a3440477b53afe1f1e0e3b0edb81840309891655e16128886e2cf0ee93be9"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "327f4a54544946a6e85740a7b414959abcf6b7af73811e3a90bf9380e6dc1439"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "3a36cae5420d53bc84b89ad27c13eb0e794f39a30923a7e9388f77231476a041"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "4226100d75fc7ab2e2cb147929ecced0d78fa0f481418659d5575f103bd5ec93"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "57d79ae1537d490b66dba10183a9dc644a2c39ec5cdc1f619d3fc91dc1591019"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "61891b94dda5a41d5ee7fa0eaa76d902a690d2edbe1a9aaa7b3476ccd2b12177"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "7283cd8887208c7b0543b44912ef2b1bfa3e18135ecc6695cfe4e1535c8c5343"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "7f98dc6ac2abb3d13bb7ade4ffdc2a758f24222546e78f748dfa4fe61a33cb88"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "8068a0132515939abe21007bafc67812b88b9f3cd3df2c42e8daadff79e9b674"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "84b91bc7fd4c665afb53884207824e9d5980d9bf533bdade47802dfb18dc63b5"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "af134161dac0825b2630549aa80477c45db4c9d9aef009f14c26cd79d2f4ae04"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "b1fccc0513c53482c9fa00c104929b99d42e8ec1887fe3cfda4c871df7805ce4"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "b724e3a76c632a350602c54521033af9b3c3997c77c34e1176a02fa168866b6c"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = "fb033d2eb031392c200cdd741258e20f7ed720b833a6d9a1536bff687ea63314"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
}

resource "aws_s3_bucket_public_access_block" "configs3bucketblockpublicaccess" {
  bucket              = "${aws_s3_bucket.configs3bucket.id}"
  provider            = "aws.euwest2"
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "configs3bucketpolicy" {
  bucket   = "${aws_s3_bucket.configs3bucket.id}"
  provider = "aws.euwest2"
  policy   = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSConfigBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.configbucketname}"
        },
        
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::${var.configbucketname}"
        },
        {
            "Sid": "AWSConfigBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.configbucketname}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::${var.configbucketname}/*",
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
