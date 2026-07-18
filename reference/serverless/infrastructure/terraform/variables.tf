variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Logical project name (used as resource prefix)"
  default     = "image-processor"
}

variable "stage" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.stage)
    error_message = "stage must be one of dev / staging / prod."
  }
}

variable "alert_topic_arn" {
  type        = string
  description = "SNS topic ARN for DLQ alerts."
}