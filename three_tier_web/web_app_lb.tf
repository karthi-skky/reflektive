resource "aws_security_group" "reflek_sg_web_lb" {
  name = "reflek_sg_web_lb"
  vpc_id = aws_vpc.reflek_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_internet_gateway.reflek_IG]

}
resource "aws_lb" "reflek_web_lb" {
  name = "reflek-web-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.reflek_sg_web_lb.id]
  subnets = aws_subnet.reflek_pub_subnet.*.id
  tags = {
    Name = "EXTERNAL-ALB"
  }
}
output "reflek_web_lb_dns_name" {
  value = aws_lb.reflek_web_lb.dns_name
}
resource "aws_alb_target_group" "reflek_web_alb_tg" {
  name     = "reflek-web-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.reflek_vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.reflek_web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.reflek_web_alb_tg.arn
  }
}
