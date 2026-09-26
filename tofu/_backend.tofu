terraform {
  backend "s3" {
    bucket                      = "opentofu-state"
    key                         = "home_server/terraform.tfstate"
    region                      = "main"
    endpoints                   = { s3 = "https://s3-storage.data.home.sauers.link" }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
