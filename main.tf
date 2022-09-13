# vim main.tf

# --------------------------------------------------------------
# Creating Security Group For 22,80,443 traffic
# --------------------------------------------------------------
resource "aws_security_group" "sg" {
      
  name        = "webserver-${var.project}-${var.env}"
  description = "Allow 80,443,22 traffic"
  
  ingress {
   
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    
  ingress {
   
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
   
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


    

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
      
       Name = "webserver-${var.project}-${var.env}"
       project = var.project
       env = var.env
  }
    
}



# --------------------------------------------------------------
# Creating keyPair
# --------------------------------------------------------------

resource "aws_key_pair" "key" {
    
    key_name   = "${var.project}-${var.env}"
    public_key = file("localkey.pub")
   tags = {
      
       Name = "${var.project}-${var.env}"
       project = var.project
       env = var.env
  }
}


# --------------------------------------------------------------
# Creating backend Instance
# --------------------------------------------------------------

resource "aws_instance"  "wordpress" {
    
    ami                    =  "ami-079b5e5b3971bd10d"
    instance_type          =  "t2.micro"
    key_name               =  aws_key_pair.key.id
    vpc_security_group_ids =  [ aws_security_group.sg.id ]
    tags = {
      
       Name = "wordpress-${var.project}-${var.env}"
       project = var.project
       env  = var.env
    }
    
    provisioner "file" {
        
      source      = "apache-install.sh"
      destination = "/tmp/apache-install.sh"

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./localkey")
        host        = self.public_ip
       }
        
    }
    
    provisioner "remote-exec" {
        
    inline = [
      "sudo chmod +x /tmp/apache-install.sh",
      "sudo /tmp/apache-install.sh"
    ]
        
    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./localkey")
        host        = self.public_ip
      }
   }
    
}

