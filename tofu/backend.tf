# Local state for now (terraform.tfstate is gitignored — back it up!).
#
# Planned migration to MinIO on TrueNAS: replace this block with an "s3"
# backend and run `tofu init -migrate-state`. Nothing else in the repo
# needs to change. Example for later:
#
# terraform {
#   backend "s3" {
#     bucket = "tofu-state"
#     key    = "home_server/terraform.tfstate"
#     region = "main"
#     endpoints                   = { s3 = "https://minio.example:9000" }
#     skip_credentials_validation = true
#     skip_region_validation      = true
#     skip_requesting_account_id  = true
#     use_path_style              = true
#   }
# }
terraform {
  backend "local" {}
}
