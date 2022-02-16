# Variable Declarations

variable "instance_count" {
    type    = number
    default = 5
}
variable "additional_volume_size" {
    type    = number
    default = 20
}
variable "volume_count" {
    type    = number
    default = 3
}
# Declare the data source
data "aws_availability_zones" "available" {
    all_availability_zones = true
    state                  = "available"
}

locals {
    az = toset(data.aws_availability_zones.available.names)
}

# Resource Code Block

# Size value changed
/*
resource "aws_ebs_volume" "ebs_volume" {
    count             = length[data.aws_availability_zones.available.names]
    availability_zone = aws_instance.sql_server.availability_zone.name
    size              = var.additional_volume_size
}
*/

resource "aws_ebs_volume" "ebs_volume" {
    for_each          = local.az
    availability_zone = each.value
    size              = var.additional_volume_size
}

/*
resource "aws_ebs_volume" "ebs_volume" {
    count             = var.instance_count * var.volume_count
    availability_zone = aws_instance.sql_server[floor(count.index / var.volume_count)].availability_zone
    size              = var.additional_volume_size[count.index % var.volume_count]
}
*/

/*
resource "aws_volume_attachment" "volume_attachment" {
    count       = var.instance_count * var.volume_count
    volume_id   = element(aws_ebs_volume.ebs_volume.*.id, count.index)
    device_name = element(var.ec2_volumes, count.index)
    instance_id = element(aws_instance.sql_server.*.id, floor(count.index / var.volume_count))
}
*/

# Instance Creation

resource "aws_instance" "sql_server" {
    ami               = "ami-005e54dee72cc1d00" # us-west-1
    instance_type     = "t2.micro"
    availability_zone = "us-west-1a"
}