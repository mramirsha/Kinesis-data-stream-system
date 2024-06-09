resource "aws_s3_bucket" "bucket" {
  bucket = "raw_babbel_${var.environment}_bucket"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}