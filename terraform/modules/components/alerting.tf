#############################################################################################################################################
# Config rules
#############################################################################################################################################


resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_READ_PROHIBITED" {

  name        = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  description = "creates a rule that lets you know if any s3 buckets are open to be read by the public"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}


resource "aws_config_config_rule" "S3_BUCKET_VERSIONING_ENABLED" {

  name        = "S3_BUCKET_VERSIONING_ENABLED"
  description = "creates a rule that lets you know if versioning is enabled"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}


resource "aws_config_config_rule" "S3_BUCKET_PUBLIC_WRITE_PROHIBITED" {

  name        = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  description = "creates a rule that lets know if any s3 buckets are open to be written to by the public"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}

resource "aws_config_config_rule" "CLOUD_TRAIL_ENABLED" {

  name        = "CLOUD_TRAIL_ENABLED"
  description = "creates a rule that lets you know if Cloud trail is enabled on your account"
  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}


resource "aws_config_config_rule" "S3_BUCKET_LOGGING_ENABLED" {

  name        = "S3_BUCKET_LOGGING_ENABLED"
  description = "creates a rule that lets you know if S3 bucket logging is enabled"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}

resource "aws_config_config_rule" "MULTI_REGION_CLOUD_TRAIL_ENABLED" {

  name        = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
  description = "creates a rule that lets you know if multi region cloud trail is enabled"

  source {
    owner             = "AWS"
    source_identifier = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}


resource "aws_config_config_rule" "S3_BUCKET_SSL_REQUESTS_ONLY" {

  name        = "S3_BUCKET_SSL_REQUESTS_ONLY"
  description = "creates a rule that lets you know if requests to any S3 buckets are HTTPS only"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }
  depends_on = ["aws_config_configuration_recorder.foo"]
}

resource "aws_config_config_rule" "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED" {

  name        = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  description = "creates a rule that lets you know is S3-SSE is enabled on your S3 buckets"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.foo"]
}

#############################################################################################################################################
# CIS Cloud Watch rules/ alarms
#############################################################################################################################################

#Creates the SNS Topic
resource "aws_sns_topic" "alarms" {
  name = "${var.sns_topic_name}"
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

#Subcribes the SNS Topic to a PagerDuty EndPoint
/*
resource "aws_sns_topic_subscription" "sns_sub_PagerDuty" {
  topic_arn                     = "${aws_sns_topic.alarms.arn}"
  protocol                      = "https"
  endpoint_auto_confirms        = true
  endpoint                      = "${var.pagerdutyendpoint}"
}
*/
# --------------------------------------------------------------------------------------------------
# CloudWatch metrics and alarms defined in the CIS benchmark.
# --------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "yada" {
  name = "${var.cloudtrail_log_group_name}"
}

resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  name           = "CW-CIS-RootUsage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-RootUsage"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage" {
  alarm_name                = "CW-CIS-RootUsage-Alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.root_usage.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for root account logins will provide visibility into the use of a fully privileged account and an opportunity to reduce the use of it."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "iam_changes" {
  name           = "CW-CIS-IAMChanges"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-IAMChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_changes" {
  alarm_name                = "CW-CIS-IAMChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.iam_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to IAM policies will help ensure authentication and authorization controls remain intact."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail_cfg_changes" {
  name           = "CW-CIS-CloudTrailCfgChanges"
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-CloudTrailCfgChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_cfg_changes" {
  alarm_name                = "CW-CIS-CloudTrailCfgChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.cloudtrail_cfg_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to CloudTrail's configuration will help ensure sustained visibility to activities performed in the AWS account."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "console_signin_failures" {
  name           = "CW-CIS-ConsoleSigninFailures"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-ConsoleSigninFailures"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_failures" {
  alarm_name                = "CW-CIS-ConsoleSigninFailures"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.console_signin_failures.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }

}

resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_cmk" {
  name           = "CW-CIS-DisableOrDeleteCMK"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-DisableOrDeleteCMK"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "disable_or_delete_cmk" {
  alarm_name                = "CW-CIS-DisableOrDeleteCMK"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.disable_or_delete_cmk.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_changes" {
  name           = "CW-CIS-S3BucketPolicyChanges"
  pattern        = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "S3BucketPolicyChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_policy_changes" {
  alarm_name                = "CW-CIS-S3BucketPolicyChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.s3_bucket_policy_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to S3 bucket policies may reduce time to detect and correct permissive policies on sensitive S3 buckets."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "aws_config_changes" {
  name           = "CW-CIS-AWSConfigChanges"
  pattern        = "{ ($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-AWSConfigChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_changes" {
  alarm_name                = "CW-CIS-AWSConfigChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.aws_config_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to AWS Config configuration will help ensure sustained visibility of configuration items within the AWS account."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  name           = "CW-CIS-SecurityGroupChanges"
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-SecurityGroupChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_changes" {
  alarm_name                = "CW-CIS-SecurityGroupChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.security_group_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to security group will help ensure that resources and services are not unintentionally exposed."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "nacl_changes" {
  name           = "CW-CIS-NACLChanges"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-NACLChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_changes" {
  alarm_name                = "CW-CIS-NACLChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.nacl_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to NACLs will help ensure that AWS resources and services are not unintentionally exposed."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "network_gw_changes" {
  name           = "CW-CIS-NetworkGWChanges"
  pattern        = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-NetworkGWChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_gw_changes" {
  alarm_name                = "CW-CIS-NetworkGWChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.network_gw_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to network gateways will help ensure that all ingress/egress traffic traverses the VPC border via a controlled path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "route_table_changes" {
  name           = "CW-CIS-RouteTableChanges"
  pattern        = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-RouteTableChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_changes" {
  alarm_name                = "CW-CIS-RouteTableChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.route_table_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to route tables will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

resource "aws_cloudwatch_log_metric_filter" "vpc_changes" {
  name           = "CW-CIS-VPCChanges"
  pattern        = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "CW-CIS-VPCChanges"
    namespace = "${var.alarm_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_changes" {
  alarm_name                = "CW-CIS-VPCChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.vpc_changes.id}"
  namespace                 = "${var.alarm_namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to VPC will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  tags                      = {    
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "alerting"
  }
}

