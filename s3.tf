#--Provision S3 Buckets
#resource "aws_s3_bucket" "nick" {
#    bucket          = "nickcipherstorage-${local.environment}"
#    force_destroy   = true
#    acl             = "private"

#    server_side_encryption_configuration {
#        rule {
#            apply_server_side_encryption_by_default {
#                sse_algorithm     = "AES256"
#            }
#        }
#    }
#    tags = {
#        Name        = "nickcipherstorage-${local.environment}"
#        Environment = local.environment
#    }
#}

#--Configure S3 Public Access

#resource "aws_s3_bucket_public_access_block" "nick" {
#    bucket                  = aws_s3_bucket.nick.id
#    block_public_acls       = true
#    block_public_policy     = true
#    ignore_public_acls      = true
#    restrict_public_buckets = true
#}
