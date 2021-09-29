/******************************************************************
  EC2 for Backend Services
******************************************************************/
resource "aws_instance" "gds_backend_ec2" {
  ami = "ami-082105f875acab993"
  instance_type =  "t2.micro"

  # Network
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]
  subnet_id = aws_subnet.public_subnet_1.id

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted = true
    volume_size = 8
  }

  user_data = base64encode(<<EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    docker run -d -e PORT=3001 -p 80:3001 ghcr.io/darryl-sw/bootcamp-gds-backend:c49d191fe1a702b2e3608f74c7c82b6024e06bbe
  EOF
  )
}

output "backend_url" {
  value = aws_instance.gds_backend_ec2.public_ip
  description = "The URL of the backend application"
}