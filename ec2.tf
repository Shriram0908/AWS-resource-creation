resource "aws_instance" "ad" {
  ami                    = "ami-cab195a5"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.windows_access.id}", "${aws_security_group.vpc_access.id}"]
  subnet_id              = "${element(aws_subnet.public.*.id, 0)}"
  private_ip             = "10.0.11.10"
  iam_instance_profile   = "${aws_iam_instance_profile.s3_access_profile.name}"
  key_name               = "${var.key_name}"
  get_password_data      = "true"

  tags {
    Name = "DC01"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-5b673c34"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.linux_access.id}", "${aws_security_group.vpc_access.id}", "${aws_security_group.web_access.id}"]
  subnet_id              = "${element(aws_subnet.public.*.id, 0)}"
  private_ip             = "10.0.11.20"
  iam_instance_profile   = "${aws_iam_instance_profile.s3_access_profile.name}"
  key_name               = "${var.key_name}"
  user_data              = "${file("${path.module}/web_deploy.sh")}"

  tags {
    Name = "WEB01"
  }
}
