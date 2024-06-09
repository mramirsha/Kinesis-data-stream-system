variable "environment" {
  description = "This has been used in multiple places to specify the environment"
  default = "dev"
}

variable "function_name" {
  default = ""
}

variable "runtime" {
  default = "python3.9"
}

variable "source_file" {
  description = "The path to lambda function file"
  default = ""
}

variable "lambda_handler" {
  default = ""
}

variable "filename" {
  default = ""
}

variable "kinesis_stream_name" {
  default = ""
}

variable "account_id" {
  default = ""
}

variable "region" {
  default = ""
}

variable "glue_table_name" {
  default = ""
}