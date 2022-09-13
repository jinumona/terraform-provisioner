# vim output.tf

output "webserver-public_ip" {
    
value = aws_instance.wordpress.public_ip
}


