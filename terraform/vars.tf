variable "aws_s3_bucket" {
  description = "Name of the bucket."
  default = "customerdata-aws1"
}



variable "region" {
  description = "The AWS region we want this bucket to live in."
  default    = "us-west-2"
}

variable "nsp_source_url" {
  default     = "https://nsphttpsgcl.prd.nsp.nike.com/test-raw-cdd-data/main"

}

variable "lambda_runtime" {
  default = "python3.7"
}


variable "lambda_handler" {
  default = "src/lambda.lambda_handler"
}


variable "lambda_source_package" {
  default = "src.zip"
}

variable "source_code_bucket" {
  default = "test3shruthi"
}

variable "iam_role" {

  default = "s3NewAccessLambda"
}
