

output "vpc_id" {
    value = aws_vpc.vpc_id.id
  
}

output "vpc_pub_snet_id" {
    value = aws_subnet.vpc_pub_snet
  
}