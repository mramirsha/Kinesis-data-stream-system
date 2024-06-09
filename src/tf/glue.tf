resource "aws_glue_catalog_database" "glue_database" {
  name = "babbel_glue_db"
  create_table_default_permission {
    permissions = ["SELECT"]

    principal {
      data_lake_principal_identifier = aws_iam_role.firehose_role.id
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = var.glue_table_name
  database_name = aws_glue_catalog_database.glue_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = aws_s3_bucket.bucket.bucket
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "babbel_${var.environment}"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "event_uuid"
      type = "string"
    }

    columns {
      name = "event_name"
      type = "string"
    }

    columns {
      name    = "created_at"
      type    = "bigint"
      comment = ""
    }

    columns {
      name    = "created_datetime"
      type    = "date"
      comment = ""
    }

    columns {
      name    = "event_type"
      type    = "string"
      comment = ""
    }

    columns {
      name    = "event_subtype"
      type    = "string"
      comment = ""
    }

  }
}