#VPC CIDR VARIABLE
variable "vpc_cidr" { 
}

#VPC SUBNET VARIABLES

variable "pub_snet" {
    type = map (object({
        cidr = string
        az = string
    }))
    
}
variable "pvt_snet" {
    type = map(object({
        cidr = string
        az = string
    }))
  
}
#IGW VARIABLE

# variable "vpc_igw_id" {
#     default = aws_vpc.vpc_id.id
  
# }

#ROUTE TABLE VARIABLES

# variable "rt_vpc_id" {
#     default =  aws_vpc.vpc_id.id
  
# }
variable "rt_cidr" {
  
  default = "0.0.0.0/0"
}

# variable "rt_igw_id" {
#     default = aws_internet_gateway.vpc_igw.id
# }

# #RTA VARIABLES
# variable "rta_rt_id" {
  
#   default = aws_route_table.vpc_rt.id
# }

# NAT GATEWAY VARIABLE

# variable "ng_pub_snet_id" {
  
# }
# variable "is_nat_required" {
  
# }