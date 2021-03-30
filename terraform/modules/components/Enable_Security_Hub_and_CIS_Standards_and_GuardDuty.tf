#############################################################################################################################################
# enable security hub / CIS Standards/ GuardDuty
#############################################################################################################################################
resource "aws_securityhub_account" "SecHub" {}


resource "aws_securityhub_standards_subscription" "SecHubCIS" {
  depends_on    = ["aws_securityhub_account.SecHub"]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_guardduty_detector" "guardddutyenable" {
  enable = true
}


/*
resource "aws_guardduty_detector" "guardddutyenable-lon" {
  provider = "aws.Requester_Lon"
  enable   = true
}
*/