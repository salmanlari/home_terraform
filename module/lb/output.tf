output "lb_output" {
    value = aws_lb.lb_id
  
}
output "tg_output" {
  
  value = aws_lb_target_group.lb_tg.arn
}