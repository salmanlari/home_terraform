
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_launch_configuration" "asg_lc_conf" {
  name_prefix           = "lc"
  image_id              = var.ami_id
  instance_type         = var.ec2_instance_type
  security_groups       = [var.sg_groups]
  key_name              = var.key_name
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                       = "asg-policy"
  scaling_adjustment         = 4
  adjustment_type            = "ChangeInCapacity"
  cooldown                   = 300
  autoscaling_group_name     = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_group" "asg" {
  #availability_zones       = data.aws_availability_zones.available.names
  # vpc_zone_identifier       = [var.pub_snet,var.pub_snet2]
   vpc_zone_identifier       = var.pub_snet
  name                      = "app-asg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.asg_lc_conf.id
  target_group_arns         = [var.tg_arns]
}