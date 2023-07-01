# provider "aws" {
#   region = "us-east-1"
#   # access_key = 
#   # secret_key = 
# }

# resource "aws_vpc" "main" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "main"
#   }
# } 
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "main"
#   }
# } 
# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id = aws_internet_gateway.gw.id 
#   }

#   tags = {
#     Name = "example"
#   }
# } 
# resource "aws_subnet" "subnet-1" {
#     vpc_id =  aws_vpc.main.id 
#     cidr_block = "10.0.1.0/24"
#     availability_zone = "us-east-1a"
#     tags = {
#         Name = "subnet-1"

#     }
  
# }
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.example.id
# }
# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow web inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "HTTPS"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
   
#   }
#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
    
#   }
#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
  
#   }
  

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_web"
#   }
# }
# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]

# }
# resource "aws_eip" "one" {
#   vpc      = true
#   network_interface = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on = [aws_internet_gateway.gw]
    

# }

# resource "aws_instance" "webserver" {
#   ami           =  "ami-04cd519d2f9578053" 
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a"
#   key_name = "Iankeypair" 

#   tags = {
#     Name = "webservy"
#   }
 

#   network_interface { 
#     device_index = 0
#     network_interface_id = aws_network_interface.web-server-nic.id


# }  
#                 user_data = <<-EOF
#                  #!/bin/bash
#                  sudo apt update -y
#                  sudo apt install apache2 -y
#                  sudo systemctl start apache2 
#                  sudo bash -c 'echo your very first webserver by attemnkeng accomplished through terraform. hurray!! > /var/www/html/index.html'                    
#                 EOF                    
# }
############################################################
# resource "aws_security_group" "elb-security-group" {
#   name        = "ALB Security Group"
#   description = "Enable HTTP/HTTPS access on Port 80/443"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "HTTP Access"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     description      = "HTTPS Access"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags   = {
#     Name = "ALB Security Group"
#   }
# }
  

# resource "aws_eip" "eip-for-nat-gateway-1" {
#   vpc    = true

#   tags   = {
#     Name = "EIP 1"
#   }
# }
 

# resource "aws_nat_gateway" "nat-gateway-1" {
#   allocation_id = aws_eip.eip-for-nat-gateway-1.id
#   subnet_id     = aws_subnet.subnet-1.id

#   tags   = {
#     Name = "Nat Gateway Public Subnet 1"
#   }
# }

# resource "aws_elb" "application_load_balancer" {
#   name               = "loadbalancer"
#   internal           = false
#   security_groups    = [aws_security_group.elb-security-group.id]
#   subnets            = [aws_subnet.subnet-1.id]
  

#   tags   = {
#     Name = "loadbalancer"
#   }

#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 8080
#     lb_protocol       = "http"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }

#   instances                   = [aws_instance.webserver.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400
  
# }

# #create autoscaling group
# #terraform create aws autoscaling group
# resource "aws_launch_template" "auto_group_temp" {
#   name_prefix   = "auto-scaling"
#   image_id      = "ami-03c7d01cf4dedc891"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "auto_temp"}
# }

# resource "aws_autoscaling_group" "auto_group" {
#   availability_zones = ["us-east-1a"]
#   desired_capacity   = 1
#   max_size           = 1
#   min_size           = 1

#   launch_template {
#     id      = aws_launch_template.auto_group_temp.id
#     version = "$Latest"
#   }
# }
             

# output "lb_url" {
#   description = "URL of load balancer"
#   value       = aws_elb.application_load_balancer
# }

resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc
  
  tags = {
    Name = var.tags
  }
}

resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.zoneA

  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.zoneB

  tags = {
    Name = "public_b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = var.zoneC

  tags = {
    Name = "public_c"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "my_sg" {
  name        = var.aws_security_group
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow http from everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow http from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_lb_target_group" "my_tg" {
  name     = "my-tg"
  target_type = "instance"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_launch_template" "my_launch_template" {

  name = "my_launch_template"
  
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key
  user_data = filebase64("server.sh")
  #user_data = filebase64("${path.module}/server.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.my_sg.id]
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                      = "my_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier       = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
  
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"    # add one instance
  cooldown               = "300"  # cooldown period after scaling
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}

# output "server_public_ip" {
#     value = aws_eip.one.public_ip
  
# }