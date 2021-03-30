    #iam
variable "Account_Alias" {}
variable "account_id" {}
variable "OutPost24-Role-Name" {}
variable "OutPost24-Policy-Name" {}
variable "Config-Role-Name" {}                     
variable "TSSSecretKeyRotationUser" {}                    
variable "FullAdmin-Role" {}                  
variable "FullAdmin-Policy" {}                            
variable "Contributor-role" {}                          
variable "Contributor-Policy" {}                          
variable "ReadOnly-Role" {}                               
variable "ReadOnly-Policy" {}                             
    #CloudTrail/ cloudwatch
variable "CloudTrail-S3-Name" {}                          
variable "CloudTrail-Trail" {}                            
variable "cloudtrail_log_group_name" {}                   
variable "region" {}                                                     
variable "alarm_namespace" {}    
variable "sns_topic_name" {}                         
    #VPC                              
#variable "VPC_Cidr" {}                          
#variable "VPC_Name" {}                          
#variable "VPC_Cidr_Ire_pub_az1" {}             
#variable "VPC_Cidr_Ire_pub_SN_az1_Name" {}     
#variable "VPC_Cidr_Ire_pub_az2" {}             
#variable "VPC_Cidr_Ire_pub_SN_az2_Name" {}   
#variable "VPC_Cidr_Ire_priv_az1" {}  
#variable "VPC_Cidr_Ire_priv_SN_az1_Name" {}     
#variable "VPC_Cidr_Ire_priv_az2" {}             
#variable "VPC_Cidr_Ire_priv_SN_az2_Name" {}    
                    
    #tagging
variable "Environment" {}                             
variable "Pillar" {}                                 
variable "Product" {}                     
