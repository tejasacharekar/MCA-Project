resource "aws_spot_instance_request" "tjSpotPrivate" {
  availability_zone = "ap-south-1a"
  ami = "ami-0bb2d072924ebcb07"
  spot_type = "one-time"
  instance_type = "t2.micro"
  spot_price = "0.03"
  wait_for_fulfillment = true
  key_name = "tjkey"
  subnet_id = aws_subnet.tjPrivate.id
  security_groups = [aws_security_group.tjSG.id]
  user_data = <<EOF
  #!/bin/bash
  echo "Changing Hostname"
  sudo hostname tejasPrivate
  echo "tejasPrivate" > /etc/hostname
  EOF

  tags = {
    "Name" = "tjSpotPR"
  }
 
}
