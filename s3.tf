resource "aws_s3_bucket" "test_bucket" {
  bucket        = "${var.environment}-test-image-bucket-stsg"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket_acl" "test_bucket_acl" {
  bucket = aws_s3_bucket.test_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "test_bucket_policy" {
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.test_bucket_policy.json
}

####################
### Data Sources ###
####################

data "aws_iam_policy_document" "test_bucket_policy" {
  statement {
    sid    = "FullAccessECSContainer"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.test_bucket.id}",
      "arn:aws:s3:::${aws_s3_bucket.test_bucket.id}/*"
    ]

    actions = [
      "s3:*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.test_ecs_role.arn]
    }
  }
}