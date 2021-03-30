#############################################################################################################################################
# VPC
#############################################################################################################################################
resource "aws_vpc" "Requester_VPC" {

  cidr_block = "${var.Requester_VPC_Cidr}"
  tags = {
    Name               = "${var.Requester_VPC_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}
#############################################################################################################################################
# public subnets in ireland
#############################################################################################################################################

resource "aws_subnet" "Requester-ire-pub-az1" {
  vpc_id            = "${aws_vpc.Requester_VPC.id}"
  cidr_block        = "${var.Requester_VPC_Cidr_Ire_pub_az1}"
  availability_zone = "eu-west-1a"
  tags = {
    Name               = "${var.Requester_VPC_Cidr_Ire_pub_SN_az1_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_subnet" "Requester-ire-pub-az2" {
  vpc_id            = "${aws_vpc.Requester_VPC.id}"
  cidr_block        = "${var.Requester_VPC_Cidr_Ire_pub_az2}"
  availability_zone = "eu-west-1b"
  tags = {
    Name               = "${var.Requester_VPC_Cidr_Ire_pub_SN_az2_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

#############################################################################################################################################
# priv subnets in ireland
#############################################################################################################################################
resource "aws_subnet" "Requester-ire-priv-az1" {
  vpc_id            = "${aws_vpc.Requester_VPC.id}"
  cidr_block        = "${var.Requester_VPC_Cidr_Ire_priv_az1}"
  availability_zone = "eu-west-1a"
  tags = {
    Name               = "${var.Requester_VPC_Cidr_Ire_priv_SN_az1_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_subnet" "Requester-ire-priv-az2" {
  vpc_id            = "${aws_vpc.Requester_VPC.id}"
  cidr_block        = "${var.Requester_VPC_Cidr_Ire_priv_az2}"
  availability_zone = "eu-west-1b"
  tags = {
    Name               = "${var.Requester_VPC_Cidr_Ire_priv_SN_az2_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_flow_log" "requester_vpc_flowlog_ire" {

  log_destination      = "${aws_cloudwatch_log_group.yada.arn}"
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  iam_role_arn         = "${aws_iam_role.all_vpc_flowlogs_role.arn}"
  vpc_id               = "${aws_vpc.Requester_VPC.id}"


}




# Create a route table for Requester
resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.Requester_VPC.id}"
  tags = {
    Name = "RT-VPC-INFOSEC-PRIVATE"
  }
}

# Create a route for Requester
resource "aws_route" "r" {
  route_table_id            = "${aws_route_table.rt.id}"
  destination_cidr_block    = "${var.Accepter_VPC_Cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.Peering_Requester.id}"

}

