resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "My security group"
  vpc_id      = var.vpc_id # Replace with your actual VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

resource "aws_launch_template" "lt_home" {

  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data              = filebase64("./home.sh")
}

resource "aws_launch_template" "lt_laptop" {

  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data              = filebase64("./laptop.sh")
}

resource "aws_launch_template" "lt_mobile" {

  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data              = filebase64("./mobile.sh")
}

resource "aws_autoscaling_group" "asg_home" {
  name             = "asg-home"
  desired_capacity = 2
  max_size         = 5
  min_size         = 2
  launch_template {
    id      = aws_launch_template.lt_home.id
    version = aws_launch_template.lt_home.latest_version
  }

  vpc_zone_identifier = [var.subnet_id_1, var.subnet_id_2]
  target_group_arns   = [aws_lb_target_group.tg_home.arn]

}

resource "aws_autoscaling_group" "asg_laptop" {
  name             = "asg-laptop"
  desired_capacity = 2
  max_size         = 5
  min_size         = 2
  launch_template {
    id      = aws_launch_template.lt_laptop.id
    version = aws_launch_template.lt_laptop.latest_version
  }
  vpc_zone_identifier = [var.subnet_id_1, var.subnet_id_2]
  target_group_arns   = [aws_lb_target_group.tg_laptop.arn]

}


resource "aws_autoscaling_group" "asg_mobile" {
  name             = "asg-mobile"
  desired_capacity = 2
  max_size         = 5
  min_size         = 2
  launch_template {
    id      = aws_launch_template.lt_mobile.id
    version = aws_launch_template.lt_mobile.latest_version
  }
  vpc_zone_identifier = [var.subnet_id_1, var.subnet_id_2]
  target_group_arns   = [aws_lb_target_group.tg_mobile.arn]

}
resource "aws_autoscaling_policy" "asg_policy_home" {
  name                   = "asg-policy-home"
  autoscaling_group_name = aws_autoscaling_group.asg_home.name
  policy_type           = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 20.0
  }
}
resource "aws_autoscaling_policy" "asg_policy_mobile" {
  name                   = "asg-policy-mobile"
  autoscaling_group_name = aws_autoscaling_group.asg_mobile.name
  policy_type           = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 20.0
  }
}
resource "aws_autoscaling_policy" "asg_policy_laptop" {
  name                   = "asg-policy-laptop"
  autoscaling_group_name = aws_autoscaling_group.asg_laptop.name
  policy_type           = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 20.0
  }
}
