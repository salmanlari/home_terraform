
variable "ec2_sgroups" {
  
}
# variable "ec2_snet" {
  
# }
variable "ec2_key" {
    
}
variable "ec2_intance_type" {  
}
variable "ec2_ami" {
  }
#   variable "pubsnet-1" {
    
#   }

#    variable "pubsnet-2" {
    
#   }
variable "ec2_pub_ip" {
  
}
variable "ec2_id" {
  type = map(object({
    subnet = string
  }))
  
}