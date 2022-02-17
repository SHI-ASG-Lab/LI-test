# Variable Declarations

variable "volume_size" {
    type    = number
    default = 20
}

variable "zones" {
    type = list(string)
    default = ["us-west-1b", "us-west-1c"]
}

# Make a set of available AZs

locals {
    az = toset(var.zones)
}

# Create one Volume per AZ

resource "aws_ebs_volume" "ebs_volume" {
    for_each          = local.az
    availability_zone = each.value
    size              = var.volume_size
}

# Instance Creation

resource "aws_instance" "sql_server" {
    ami               = "ami-005e54dee72cc1d00" # us-west-1
    instance_type     = "t2.micro"
    availability_zone = "us-west-1a"
}
