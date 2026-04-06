data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "web_server" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.enable_http ? [1] : []
    content {
      from_port   = var.http_port
      to_port     = var.http_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name} Security Group"
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]

  user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd

      if [ "${var.http_port}" != "80" ]; then
        sed -i 's/^Listen 80/Listen ${var.http_port}/' /etc/httpd/conf/httpd.conf
      fi

      cat > /var/www/html/index.html <<HTML
      <h1>Welcome to ${var.instance_name}!</h1>
      <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
      <p>Region: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
      <p>Port: ${var.http_port}</p>
      <p>Created by Terraform</p>
      HTML

      systemctl start httpd
      systemctl enable httpd
  EOF

  tags = {
    Name = var.instance_name
    Type = "Web Server"
  }
}
