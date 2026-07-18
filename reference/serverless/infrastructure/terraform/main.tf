# Infrastructure: ImageProcessor (Terraform)
# Bootstraps IAM-external resources used by serverless.yml & lab.

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------
# S3 buckets (raw input + processed outputs share one bucket by prefix).
# ----------------------------------------------------------------------------
resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-${var.stage}-images"
  tags = { Name = "images" Project = var.project_name }
}

resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_lifecycle_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "expire-raw"
    prefix = "raw/"
    status = "Enabled"
    expiration { days = 30 }
  }

  rule {
    id     = "expire-thumb"
    prefix = "thumb/"
    status = "Enabled"
    expiration { days = 365 }
  }
}

# ----------------------------------------------------------------------------
# DynamoDB: single-table upload metadata.
# ----------------------------------------------------------------------------
resource "aws_dynamodb_table" "uploads" {
  name         = "${var.project_name}-${var.stage}-uploads"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uploadId"
  attribute {
    name = "uploadId"
    type = "S"
  }
  point_in_time_recovery { enabled = true }
  tags = { Project = var.project_name }
}

# ----------------------------------------------------------------------------
# SQS queues: thumbnail processing + DLQs.
# ----------------------------------------------------------------------------
resource "aws_sqs_queue" "thumbnail" {
  name              = "${var.project_name}-${var.stage}-thumbs"
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.thumbnail_dlq.arn
    maxReceiveCount      = 3
  })
}

resource "aws_sqs_queue" "thumbnail_dlq" {
  name                    = "${var.project_name}-${var.stage}-thumbs-dlq"
  message_retention_seconds = 1209600
}

# ----------------------------------------------------------------------------
# CloudWatch alarms: DLQ depth.
# ----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "thumb_dlq" {
  alarm_name          = "${var.project_name}-thumb-dlq-depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 60
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  threshold           = 0
  dimensions = {
    QueueName = aws_sqs_queue.thumbnail_dlq.name
  }
  alarm_actions = [var.alert_topic_arn]
}