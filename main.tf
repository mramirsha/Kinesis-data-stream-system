module "babbel_firehouse_delivery" {
  source = "./src/tf"
  environment = "dev"
  function_name = "firehose_lambda_processor"
  lambda_handler = "lambda.lambda_handler"
  filename = "processor_lambda.zip"
  source_file = "${path.module}/src/py/lambda_functions/processor_lambda/process_records.py"
  kinesis_stream_name = ""
  account_id = ""
  region = ""
  glue_table_name = "babbel_raw_event_table"
}