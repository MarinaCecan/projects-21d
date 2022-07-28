resource "aws_launch_configuration" "as_conf" {
  name   = "packer-image-web"
  image_id      = "ami-0aa74b81c3b1311d4"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_app.id]
}
resource "aws_placement_group" "web" {
  name     = "web"
  strategy = "spread"
}

resource "aws_autoscaling_group" "web" {
  name                      = "asg-terraform-web"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.web.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [aws_subnet.public.id, aws_subnet.public2.id]
 

  tag {
    key                 = "Name"
    value               = "web-exchangeapp"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn    = aws_lb_target_group.test.arn
}
