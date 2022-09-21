#LOAD BALANCER

resource "aws_lb" "lb_id" {
  name               = "awslb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.lb_sgroups]
  subnets            = var.lb_pub_snets

  enable_deletion_protection = false

  tags = {
    Environment = "${terraform.workspace}_lb"
  }
}

resource "aws_lb_listener" "lb_listener_attach" {
  load_balancer_arn = aws_lb.lb_id.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}



# #target group

resource "aws_lb_target_group" "lb_tg" {
  name            = var.tg_name
  port            = var.port
  protocol        = "HTTP"
  vpc_id          = var.vpc_id
  target_type     = var.tg_type
}

# lb_target_group_attachment

# resource "aws_lb_target_group_attachment" "lb_tga" {
# #count               = length(var.snets)
# for_each             = var.ec2_lb
#   target_group_arn   = aws_lb_target_group.lb_tg.arn
#   # target_id        = var.ec2-id
#   target_id          = each.value
#   port               = var.port
# }
