data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

}

resource "aws_iam_policy" "firehose_policy" {
  name   = "firehose_s3_policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        "Effect" = "Allow",
        "Action" = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Resource" = [
          "arn:aws:s3:::raw_babbel_${var.environment}_bucket",
          "arn:aws:s3:::raw_babbel_${var.environment}_bucket/*"
        ]
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        "Resource" = "arn:aws:kinesis:${var.region}:${var.account_id}:stream/${var.kinesis_stream_name}"
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:PutLogEvents"
        ],
        "Resource" = [
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:babbel_${var.environment}_firehose:log-stream:babbel_${var.environment}_firehose_log_stream"
        ]
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" = [
          "arn:aws:lambda:${var.region}:${var.account_id}:function:${var.function_name}:$LATEST"
        ]
      }
    ]
  }
  )
}

resource "aws_iam_role" "firehose_role" {
  name                = "firehose_${var.environment}_role"
  assume_role_policy  = data.aws_iam_policy_document.firehose_assume_role.json
  managed_policy_arns = [aws_iam_policy.firehose_policy.arn]

}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_processor_iam" {
  name               = "lambda_processor_${var.environment}_iam"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
