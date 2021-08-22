resource "aws_s3_bucket_object" "html" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "maintenance-page.html"
  source       = "maintenance-page.html"
  content_type = "text/html"

  etag = filemd5("maintenance-page.html")
}
