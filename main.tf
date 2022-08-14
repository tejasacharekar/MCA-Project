provider "aws" {
    region = "ap-south-1"
    default_tags {
      tags = {
        Owner = "Tejas"
        Purpose = "Project"
      }
    }
}

# VPC for network
resource "aws_vpc" "tjVPC" {
  cidr_block = "192.168.1.0/24"
  tags = {
    "Name" = "tjProject"
  }
}

# IGW for VPC Subnet
resource "aws_internet_gateway" "tjIGW" {
    vpc_id = aws_vpc.tjVPC.id
    tags = {
      "Name" = "tjIGW"
    }
  
}

# Public Subnet
resource "aws_subnet" "tjPublic" {
    vpc_id = aws_vpc.tjVPC.id
    cidr_block = "192.168.1.0/25"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "tjPublicSub"
    }
  
}

# Route for Internet Gateway for Public Subnet
resource "aws_route" "publicIGW" {
    route_table_id = aws_route_table.tjPublic.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tjIGW.id
  
}

# # EIP for NAT gateway
# resource "aws_eip" "tjeip" {
#     vpc = true
#     depends_on = [
#         aws_internet_gateway.tjIGW
#     ]
  
# }
# # NAT Gateway for privat subnet
# resource "aws_nat_gateway" "tjNAT" {
#     subnet_id = aws_subnet.tjPrivate.id
#     allocation_id = aws_eip.tjeip.id
#     tags = {
#       "Name" = "tjNAT",
#       "Owner" = local.owner,
#       "Purpose" = local.purpose
#     }
#     depends_on = [
#       aws_internet_gateway.tjIGW
#     ]
  
# }


# Private Subnet
resource "aws_subnet" "tjPrivate" {
    vpc_id = aws_vpc.tjVPC.id
    cidr_block = "192.168.1.128/25"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = false
    tags = {
      "Name" = "tjPrivateSub"
    }
  
}

# Route table for private subnet
resource "aws_route_table" "tjPrivate" {
    vpc_id = aws_vpc.tjVPC.id
    tags = {
      "Name" = "RTPrivate"
    }
  
}

# Route table for public subnet
resource "aws_route_table" "tjPublic" {
    vpc_id = aws_vpc.tjVPC.id
    tags = {
      "Name" = "RTPublic"
    }
  
}

#Route for NAT
# resource "aws_route" "privateNATGW" {
#   route_table_id = aws_route_table.tjPrivate.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.tjNAT.id
# }

resource "aws_route_table_association" "tjRTAPB" {
    subnet_id = aws_subnet.tjPublic.id
    route_table_id = aws_route_table.tjPublic.id
  
}

resource "aws_route_table_association" "tjRTAPR" {
    subnet_id = aws_subnet.tjPrivate.id
    route_table_id = aws_route_table.tjPrivate.id
  
}

# Security Group for VPC
resource "aws_security_group" "tjSG" {
    name = "tjSecurityGP"
    description = "allow required port"
    vpc_id = aws_vpc.tjVPC.id
    tags = {
      "Name" = "tjsg"
    }

    ingress  {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

    ingress  {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
      description = "ICMP"
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
  
}

output "privateIP" {
  value = aws_spot_instance_request.tjSpotPrivate.private_ip
}

output "publicIP" {
  value = aws_spot_instance_request.tjSpotPublic.public_ip
}
