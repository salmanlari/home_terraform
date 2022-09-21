output "sg_id_out" {
  value = {for k,v in aws_security_group.aws_sg: k => v.id}
}