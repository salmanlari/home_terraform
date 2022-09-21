
# output "ec2_output" {
#   value= aws_instance.aws_ec2.id
# }
output "ec2_id_output" {
  value = {for k,v in aws_instance.aws_ec2: k=> v.id}
}