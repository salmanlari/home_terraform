provider "aws" {
    region = "ap-south-1"
    
}  

#NETWORK MODULE

module "nw" {
    source = "./module/nw"
    vpc_cidr= "10.0.0.0/22"
pub_snet ={
    pub_sub-1 ={
        az = "ap-south-1a"
        cidr ="10.0.0.0/24"

    },
    pub_sub-2 ={
        az = "ap-south-1b"
        cidr = "10.0.1.0/24"
    }
}
  pvt_snet ={
    pvt_sub-1={
        az = "ap-south-1a"
        cidr = "10.0.2.0/24"
    },
    pvt_sub-2 ={
        az ="ap-south-1b"
        cidr = "10.0.3.0/24"
    }
  }
#  is_nat_required = false
#  ng_pub_snet_id = "pub_sub-1"
 }
 output "pub-snet-id" {
   value = lookup(module.nw.vpc_pub_snet_id,"pub_sub-1",null).id
 }

# #SECURITY GROUP MODULE

module "sg" {
    source = "./module/sg"
    sg_details = {
        "ec2-sg" ={
     name         = "aws_ec2"
     description  = "all incoming"
     vpc_id       = module.nw.vpc_id

  ingress_rules =[
    {
        from_port    = "80"
        to_port      = "80"
        protocol     = "tcp"
        cidr_blocks  =["0.0.0.0/0"]
        self         = null
},
  {
        from_port     = "22"
         to_port      = "22"
        protocol      = "tcp"
        cidr_blocks   = ["0.0.0.0/0"]
         self         =  null
}

  ]
}

 "sg_lb" = {
    name         = "aws_lb"
     description  = "all incoming"
     vpc_id       = module.nw.vpc_id

  ingress_rules =[
    {
        from_port    = "80"
        to_port      = "80"
        protocol     = "tcp"
        cidr_blocks  =["0.0.0.0/0"]
        self         = null
}
  ]
}
 }
}

    
  #ec2 module

# module "ec2" {
# source                 = "./module/ec2"
#  ec2_intance_type      = "t2.micro"
#  ec2_ami               = "ami-068257025f72f470d"
#  ec2_key               = "ec2_key"
# #  ec2_snet              = lookup(module.nw.vpc_pub_snet_id, "pub_sub-1", null).id 
# ec2_id={
#   ec2-1={
#     subnet = lookup(module.nw.vpc_pub_snet_id ,"pub_sub-1",null).id
#   },
#   ec2-2={
#     subnet = lookup(module.nw.vpc_pub_snet_id,"pub_sub-2",null).id
#   }
  
#   }
#  ec2_sgroups           = lookup(module.sg.sg_id_out,"ec2-sg",null)
#  ec2_pub_ip            = true
# }


# #lb module

module "lb" {
    source               = "./module/lb"
    lb_sgroups           = lookup(module.sg.sg_id_out,"sg_lb",null)
    lb_pub_snets         = [lookup(module.nw.vpc_pub_snet_id,"pub_sub-1",null).id, lookup(module.nw.vpc_pub_snet_id,"pub_sub-2",null).id]
    lb_type              = "application"
     tg_name             = "awstg"
     port                = "80"
     vpc_id              = module.nw.vpc_id
     tg_type             = "instance"
    # ec2-id             = module.ec2.ec2_output
    #  ec2_lb              = module.ec2.ec2_id_output
   
}

# #ASG MODULE
module "asg" {
source               = "./module/asg"  
ami_id               = "ami-068257025f72f470d"
ec2_instance_type    = "t2.micro"
sg_groups            = lookup(module.sg.sg_id_out,"sg_lb",null)
key_name             = "ec2_key"
tg_arns              = module.lb.tg_output
# pub_snet             = lookup(module.nw.vpc_pub_snet_id, "pub_sub-1",null).id
# pub_snet2            = lookup(module.nw.vpc_pub_snet_id, "pub_sub-2",null).id
pub_snet = [lookup(module.nw.vpc_pub_snet_id,"pub_sub-1",null).id, lookup(module.nw.vpc_pub_snet_id,"pub_sub-2",null).id]

}