#############################################################################################################################################
# IAM Password Policy - CIS 1.5-1.11
#############################################################################################################################################

#Sets the IAM Password Policy for Users
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 15
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}
#############################################################################################################################################
# IAM Users, Roles, Groups & Policys
#############################################################################################################################################
#Role for OutPost24 scans

resource "aws_iam_role" "config_iam_role" {
  name               = "${var.Config-Role-Name}"
  description        = "creates an IAM role that allows changes to AWS Config"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

#allows config to put to S3 bucket
resource "aws_iam_role_policy" "config_allow_put" {
  name = "aws-config-allow"
  role = "${aws_iam_role.config_iam_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "config:Put*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "config-attach" {
  role       = "${aws_iam_role.config_iam_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}




#Create a user who can be used for key rotation in TSS
resource "aws_iam_user" "TSSAccessKeyRotationServiceAccount" {
  name = "${var.TSSSecretKeyRotationUser}"
}

#role for full admin access with trust policy to Azure Active Directory
resource "aws_iam_role" "IAM-Role-FullAdmin" {
  name = "${var.FullAdmin-Role}"
  #trust role to XML SAML file
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:saml-provider/AAD"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}



#Policy for full admin access
resource "aws_iam_policy" "IAM-Policy-FullAdmin" {
  name        = "${var.FullAdmin-Policy}"
  description = "Allows iam access to us-east-1, eu-west-1 and eu-west-2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
                "aws-portal:*",
                "awsbillingconsole:*",
                "budgets:*",
                "cur:*",
                "iam:*",
                "organizations:*"
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "eu-west-1",
                        "eu-west-2",
                        "eu-central-1"
                    ]
                }
            }
        }
    ]
}
EOF
}

#attaches a policy to a role that can be used for Full Admin Access
resource "aws_iam_role_policy_attachment" "IAM-Group-Member-FullAdmin" {
    role = "${aws_iam_role.IAM-Role-FullAdmin.name}"
    policy_arn = "${aws_iam_policy.IAM-Policy-FullAdmin.arn}"
}

resource "aws_iam_group" "IAM-Group-FullAdmin" {
  name = "IAM-Group-FullAdmin-EU"
}

resource "aws_iam_group_policy_attachment" "FullAdmin-attach" {
  group = "${aws_iam_group.IAM-Group-FullAdmin.name}"
  policy_arn = "${aws_iam_policy.IAM-Policy-FullAdmin.arn}"
}

#role for full admin access with trust policy to Azure Active Directory
resource "aws_iam_role" "IAM-Role-Contributor" {
  name = "${var.Contributor-role}"
  #trust role to XML SAML file
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:saml-provider/AAD"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

#Policy for full admin access
resource "aws_iam_policy" "IAM-Policy-Contributor" {
  name        = "${var.Contributor-Policy}"
  description = "Allows Contributor access to us-east-1, eu-west-1 and eu-west-2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListUsersForConsole",
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedGroupPolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListAttachedUserPolicies",
                "iam:ListEntitiesForPolicy",
                "iam:ListGroupPolicies",
                "iam:ListGroups",
                "iam:ListGroupsForUser",
                "iam:ListInstanceProfiles",
                "iam:ListInstanceProfilesForRole",
                "iam:ListPolicies",
                "iam:ListPolicyVersions",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "iam:ListRoleTags",
                "iam:ListUsers",
                "iam:ListUserTags",
                "iam:ListGroupsForUser",
                "iam:GetGroup",
                "iam:ListUserPolicies",
                "iam:GetUser",
                "iam:ListSSHPublicKeys",
                "iam:ListAccessKeys",
                "iam:ListServiceSpecificCredentials",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:ListSAMLProviders",
                "iam:GetAccountSummary",
                "iam:GetAccessKeyLastUsed",
                "iam:GetLoginProfile",
                "iam:ListMFADevices",
                "iam:ListSigningCertificates",
                "iam:ListPoliciesGrantingServiceAccess",
                "iam:ListOpenIDConnectProviders",
                "iam:GetPolicy",
                "iam:PassRole"
            ],
            "Resource": "arn:aws:iam::*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetServiceLastAccessedDetails",
                "iam:GetAccountSummary",
                "iam:ListAccountAliases",
                "iam:GetAccountSummary"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "NotAction": [
                "aws-portal:*",
                "awsbillingconsole:*",
                "budgets:*",
                "cur:*",
                "iam:*",
                "organizations:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "eu-west-1",
                        "eu-west-2",
                        "eu-central-1"
                    ]
                }
            }
        }
    ]
}
EOF
}

#attaches a policy to a role that can be used for Full Admin Access
resource "aws_iam_role_policy_attachment" "IAM-Group-Member-Contributor" {
  role = "${aws_iam_role.IAM-Role-Contributor.name}"
  policy_arn = "${aws_iam_policy.IAM-Policy-Contributor.arn}"
}

resource "aws_iam_group" "IAM-Group-Contributor" {
  name = "IAM-Group-Contributor-EU"
}

resource "aws_iam_group_policy_attachment" "Contributor-attach" {
  group = "${aws_iam_group.IAM-Group-Contributor.name}"
  policy_arn = "${aws_iam_policy.IAM-Policy-Contributor.arn}"
}

#
#
#
#
###importfromhere
#role for full admin access with trust policy to Azure Active Directory
resource "aws_iam_role" "IAM-Role-ReadOnly" {
  name = "${var.ReadOnly-Role}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:saml-provider/AAD"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}


#Policy for ReadOnly billing access
resource "aws_iam_policy" "IAM-Policy-ReadOnly" {
  name        = "${var.ReadOnly-Policy}"
  description = "Allows ReadOnly access to us-east-1, eu-west-1 and eu-west-2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "aws-portal:ViewPaymentMethods",
                "aws-portal:ViewAccount",
                "aws-portal:ViewBilling",
                "aws-portal:ViewUsage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#attaches the billing read policy to a role that can be used for Read Only Access
resource "aws_iam_role_policy_attachment" "IAM-Group-Member-Read-Billing-Only" {
    role = "${aws_iam_role.IAM-Role-ReadOnly.name}"
    policy_arn = "${aws_iam_policy.IAM-Policy-ReadOnly.arn}"
}

# attached the read only access role to 
resource "aws_iam_role_policy_attachment" "IAM-Group-Member-Read-Only" {
    role = "${aws_iam_role.IAM-Role-ReadOnly.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group" "IAM-Group-Read-Only" {
  name = "IAM-Group-Read-Only-EU"
}

resource "aws_iam_group_policy_attachment" "billing-attach" {
  group = "${aws_iam_group.IAM-Group-Read-Only.name}"
  policy_arn = "${aws_iam_policy.IAM-Policy-ReadOnly.arn}"
}

resource "aws_iam_group_policy_attachment" "readonly-attach" {
  group = "${aws_iam_group.IAM-Group-Read-Only.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#######
resource "aws_iam_role" "all_vpc_flowlogs_role" {
  name = "AWS-flowlogs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "all_vpc_flowlogs_policy" {
  name = "AWS-flowlogs-Policy"
  role = "${aws_iam_role.all_vpc_flowlogs_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-to-cloudwatch-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
#########################################################################################
#fix
resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "cloudtrail-policy"
  role = "${aws_iam_role.cloudtrail_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream"],
      "Resource": [
        
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:${aws_cloudwatch_log_group.yada.id}:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": [
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:${aws_cloudwatch_log_group.yada.id}:log-stream:*"
      ]
    },
    {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::"
    },
    {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::"
        }
  ]
}
EOF
}

/*
    #{
        "Effect": "Allow",
        "Action": ["kms:*"],
        "Resource": [
          "${aws_kms_key.CloudTrailLogs.arn}"
          ]
    },
*/
