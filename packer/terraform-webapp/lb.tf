resource "aws_lb" "test" {
  name               = "exchangeapp-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id,aws_security_group.lb2.id]
  subnets = [aws_subnet.public.id , aws_subnet.public2.id ]


  enable_deletion_protection = false


  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}




resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
