resource "aws_instance" "Web_Server1" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sgwebservers.name]
  key_name = "awsui"

  connection {
     type        = "ssh"
     user        = "ec2-user"
     host        = self.public_ip
     private_key = "${file("/Users/nick/Code/learn-terraform-aws-instance/awsui.pem")}"
  }


  provisioner "remote-exec" { 
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd mariadb-server",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      ]
  }

  tags = {
    Name = "WebServer1-${local.environment}"
    Environment = "${local.environment}"
  }


}

resource "aws_instance" "Web_Server2" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sgwebservers.name]
  key_name = "awsui"

  connection {
     type        = "ssh"
     user        = "ec2-user"
     host        = self.public_ip
     private_key = "${file("/Users/nick/Code/learn-terraform-aws-instance/awsui.pem")}"
  }
  
  provisioner "remote-exec" { 
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd mariadb-server",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      ]
  }
  
  tags = {
    Name = "WebServer2-${local.environment}"
    Environment = "${local.environment}"
  }
}

resource "aws_instance" "Web_Server3" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sgwebservers.name]  
  key_name = "awsui"

  connection {
     type        = "ssh"
     user        = "ec2-user"
     host        = self.public_ip
     private_key = "${file("/Users/nick/Code/learn-terraform-aws-instance/awsui.pem")}"
  }
  
  provisioner "remote-exec" { 
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd mariadb-server",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      ]
  }

  tags = {
    Name = "WebServer3-${local.environment}"
    Environment = "${local.environment}"
  }
}

resource "aws_instance" "nick_bastion" {
    ami           = "ami-0800fc0fa715fdcfe"
    instance_type               = "t2.micro"
    key_name                    = "awsui"
    subnet_id                   = aws_subnet.nick_bastion.id
    vpc_security_group_ids      = [aws_security_group.nick_bastion.id]
    tags = {
        Name        = "Bastion-${local.environment}"
        Environment = "${local.environment}"
    }
}

resource "aws_instance" "nick_private" {
    ami           = "ami-0800fc0fa715fdcfe"
    instance_type               = "t2.micro"
    key_name                    = "awsui"
    subnet_id                   = aws_subnet.nick_private.id
    vpc_security_group_ids      = [aws_security_group.nick_private.id]
    tags = {
        Name        = "Private-${local.environment}"
        Environment = "${local.environment}"
    }
}