resource "aws_cloudwatch_log_group" "babbel_firehose_group" {
  name = "babbel_${var.environment}_firehose"
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "babbel_${var.environment}_firehose_log_stream"
  log_group_name = aws_cloudwatch_log_group.babbel_firehose_group.name
}