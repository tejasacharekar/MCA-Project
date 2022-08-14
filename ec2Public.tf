resource "aws_spot_instance_request" "tjSpotPublic" {
  availability_zone = "ap-south-1a"
  ami = "ami-079b5e5b3971bd10d"
  spot_type = "one-time"
  instance_type = "t2.micro"
  spot_price = "0.03"
  wait_for_fulfillment = true
  key_name = "tjkey"
  subnet_id = aws_subnet.tjPublic.id
  security_groups = [aws_security_group.tjSG.id]
  
  tags = {
    "Name" = "tjSpotPB"
  }
}
