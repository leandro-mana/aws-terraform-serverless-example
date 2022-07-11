environment           = "dev"
owner                 = "data-engineering"
project               = "data-core"
log_retention_in_days = 30

# Movies App
movies_app_ddb_table          = "movies"
movies_app_ddb_billing_mode   = "PROVISIONED"
movies_app_ddb_read_capacity  = 10
movies_app_ddb_write_capacity = 10
movies_app_ddb_hash_key       = "year"
movies_app_ddb_range_key      = "title"