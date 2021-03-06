resource "aws_iam_role" "role_s3_access" {
  name = "S3_Full_access"
  path = "/"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": [
      "sts:AssumeRole"
    ],
    "Principal": {
    "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = "${aws_iam_role.role_s3_access.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"
  role = "${aws_iam_role.role_s3_access.name}"
}
