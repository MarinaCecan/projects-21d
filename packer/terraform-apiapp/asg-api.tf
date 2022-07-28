resource "aws_launch_configuration" "api" {
  name   = "packer-image-api"
  image_id      = "ami-0441681a30182fb6e"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_app.id]
}
resource "aws_placement_group" "api" {
  name     = "apiapp"
  strategy = "spread"
}

resource "aws_autoscaling_group" "api" {
  name                      = "asg-terraform-api"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.api.id
  launch_configuration      = aws_launch_configuration.api.name
  vpc_zone_identifier       = [aws_subnet.public.id, aws_subnet.public2.id]
 

  tag {
    key                 = "Name"
    value               = "api-exchangeapp"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.api.id
  lb_target_group_arn    = aws_lb_target_group.api.arn
}
