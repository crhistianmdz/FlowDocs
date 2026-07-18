output "images_bucket_name" {
  value = aws_s3_bucket.images.bucket
}

output "images_bucket_arn" {
  value = aws_s3_bucket.images.arn
}

output "uploads_table_name" {
  value = aws_dynamodb_table.uploads.name
}

output "uploads_table_arn" {
  value = aws_dynamodb_table.uploads.arn
}

output "thumbnail_queue_url" {
  value = aws_sqs_queue.thumbnail.url
}

output "thumbnail_queue_arn" {
  value = aws_sqs_queue.thumbnail.arn
}

output "thumbnail_dlq_arn" {
  value = aws_sqs_queue.thumbnail_dlq.arn
}