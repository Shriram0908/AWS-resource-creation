resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name       = "Terraform-Test"
    Created_by = "${var.vpc_tag}"
  }
}

resource "aws_subnet" "Public" {
  count                   = 2
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${lookup(var.public_subnet_cidr_block)}"
  map_public_ip_on_launch = true
}
