
resource "aws_s3_bucket" "web" {
  bucket = var.bucket_name
  acl = "private"
  versioning {
    enabled = true
  }
}
resource "aws_s3_bucket_object" "web" {
  bucket = aws_s3_bucket.web.id
  key = "index.html"
  source = "./index.html"
  etag = filemd5("./index.html")
}
resource "aws_s3_bucket" "web_bucket" {
  bucket = "web-bucket"
  acl = "private"
}
