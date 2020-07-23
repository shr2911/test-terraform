resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.iam_role}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
provider "aws" {
  version = "2.43.0"
  /*version = "2.17.0"*/
  region = "${var.region}"
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.aws_s3_bucket}"
  #acl = "public"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": "*",
          "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl",
              "s3:GetObject",
              "s3:GetObjectAcl",
              "s3:DeleteObject"
          ],
          "Resource": [
              "arn:aws:s3:::customerdata-aws1/*"
          ]
      }
  ]
}
EOF
}
resource "aws_lambda_permission" "with_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = "Customer1"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.bucket.arn}"
}

data "archive_file" "lambdazip" {
  type        = "zip"
  output_path = "src.zip"
  source_dir = "src/"
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = "${var.source_code_bucket}"
  key    = "${data.archive_file.lambdazip.output_path}"
  source = "${data.archive_file.lambdazip.output_path}"
  acl = "public-read-write"
}

resource "aws_lambda_function" "lambda-function" {
  s3_bucket         = "${aws_s3_bucket_object.file_upload.bucket}"
  s3_key            = "${aws_s3_bucket_object.file_upload.key}"
  s3_object_version = "${aws_s3_bucket_object.file_upload.version_id}"
  function_name     = "Customer1"
  role              = "${aws_iam_role.iam_for_lambda.arn}" # (not shown)
  handler           = "core/lambda.lambda_handler"
  runtime           = "python3.7"
  source_code_hash  = "${base64sha256(file("${aws_s3_bucket_object.file_upload.key}"))}"


  environment {
    variables = {
      nsp_source_url      = "${var.nsp_source_url}"
    }
  }

  dead_letter_config {
    target_arn = "${aws_sqs_queue.dlq.arn}"
  }
}


resource "aws_sqs_queue" "dlq" {
  name = "${var.app_configs["project"]}-${var.app_configs["domain"]}-${var.app_configs["domain_object"]}-${var.data_maturity}-${var.app}-dlq"
  delay_seconds = 0
  max_message_size = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = "300"
}


resource "aws_lambda_function_event_invoke_config" "lambda-function-retry" {
function_name                = "${aws_lambda_function.lambda-function.function_name}"


maximum_event_age_in_seconds = 280
maximum_retry_attempts       = 2
qualifier     = "${aws_lambda_function.lambda-function.version}"

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda-function.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}
