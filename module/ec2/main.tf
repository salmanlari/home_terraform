# EC2 INSTANCE

resource "aws_instance" "aws_ec2" {
  for_each         = var.ec2_id
  ami              = var.ec2_ami
  instance_type    = var.ec2_intance_type
  # subnet_id        = var.ec2_snet
  subnet_id = each.value ["subnet"]

  security_groups  = [var.ec2_sgroups]
  key_name         = var.ec2_key
  associate_public_ip_address = var.ec2_pub_ip
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install nginx -y
#     sudo apt install php-fpm php-mysql -y
#     sudo apt install awscli -y
#     sudo apt install mysql-server -y
#     sudo cd /var/www/html
#     sudo wget http://wordpress.org/latest.tar.gz
#     sudo tar -xzvf latest.tar.gz
#     sudo mv -f wordpress/* /var/www/html
#     sudo chown -R www-data:www-data /var/www/html/
#     sudo chmod -R 755 /var/www/html/
# EOF


tags = {
     Name = "${terraform.workspace}_ec2"
   }
}