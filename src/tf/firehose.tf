resource "aws_kinesis_firehose_delivery_stream" "babbel_s3_stream" {
  name        = "kinesis-firehose-babbel-${var.environment}-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.bucket.arn

    buffering_size     = 128
    buffering_interval = 300

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.babbel_firehose_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }

    dynamic_partitioning_configuration {
      enabled = "true"
    }

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_database.glue_database.name
        role_arn      = aws_iam_role.firehose_role.arn
        table_name    = aws_glue_catalog_table.aws_glue_catalog_table.name
      }
    }

    prefix              = "data/event_type=!{partitionKeyFromQuery:event_type}/year-month-day=!{timestamp:yyyy-MM-dd}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        }
        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "3"
        }
        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "60"
        }
      }
    }
  }
  kinesis_source_configuration {
    kinesis_stream_arn = "arn:aws:kinesis:${var.region}:${var.account_id}:stream/${var.kinesis_stream_name}"
    role_arn           = aws_iam_role.firehose_role.arn
  }
  tags = {
    Owner = "Babbel"
  }
}
