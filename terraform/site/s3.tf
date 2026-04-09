resource "aws_s3_bucket" "site" {
  bucket = "devopssampleapp-frontend"
}

# Block ALL public access 
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront to access S3
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = aws_s3_bucket.site.id

  depends_on = [
    aws_cloudfront_distribution.cdn
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccess"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.site.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}
