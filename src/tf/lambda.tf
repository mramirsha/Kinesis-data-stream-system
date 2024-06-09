data "archive_file" "python_lambda_package" {
  type = "zip"
  source_file = var.source_file
  output_path = var.filename
}

resource "aws_lambda_function" "lambda_processor" {
  filename      = var.filename
  function_name = var.function_name
  role          = aws_iam_role.lambda_processor_iam.arn
  handler       = var.lambda_handler
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  runtime       = var.runtime
}