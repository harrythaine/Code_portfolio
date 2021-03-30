#TESTESTES  
# Require TF version to most recent

terraform {
  #required_version = "=0.12.4"
   backend "s3" {
    bucket         = "bucketname"
    key            = "state.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dydbname"
    encrypt        = true
    
  }
}

# Download any stable version in AWS provider of 2.19.0 or higher in 2.19 train
provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.19.0"

}



# Call the seed_module to build our ADO seed info
module "ado_seed" {
  source                       = "./modules/ado_seed"
  name_of_s3_bucket            = ""
  dynamo_db_table_name         = ""
  iam_user_name                = ""
  ado_iam_role_name            = ""
  aws_iam_policy_permits_name  = ""
  aws_iam_policy_assume_name   = ""
}

module "components" {
    source                                      = "./modules/components"
    #provider
    region                                      = "eu-west-1"
    #IAM
    Account_Alias                               = ""
    account_id                                  = ""
    OutPost24-Role-Name                         = ""
    OutPost24-Policy-Name                       = ""
    Config-Role-Name                            = ""
    FullAdmin-Role                              = ""
    FullAdmin-Policy                            = ""
    Contributor-role                            = ""
    Contributor-Policy                          = ""
    ReadOnly-Role                               = ""
    ReadOnly-Policy                             = ""
    #CloudTrail/ cloudwatch
    CloudTrail-S3-Name                          = ""
    CloudTrail-Trail                            = ""
    cloudtrail_log_group_name                   = "CloudTrail/DefaultLogGroup"
    alarm_namespace                             = ""
    sns_topic_name                              = "" 
    #VPC
    VPC_Cidr                          = ""
    VPC_Name                          = ""
    VPC_Cidr_Ire_pub_az1              = ""
    VPC_Cidr_Ire_pub_SN_az1_Name      = ""
    VPC_Cidr_Ire_pub_az2              = ""
    VPC_Cidr_Ire_pub_SN_az2_Name      = ""
    VPC_Cidr_Ire_priv_az1             = ""
    VPC_Cidr_Ire_priv_SN_az1_Name     = ""
    VPC_Cidr_Ire_priv_az2             = ""
    VPC_Cidr_Ire_priv_SN_az2_Name     = ""
    VPC_Cidr                           = ""
    VPC_Cidr                          = ""
    VPC_Cidr_Lon                      = ""
    VPC_Name_Lon                      = ""
    #tagging
    Environment                             = ""
    Pillar                                  = ""
    Product                                 = ""
}