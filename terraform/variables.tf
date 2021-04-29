variable "region" {
  default = "eu-west-3"
}

variable "secret_key" {}

variable "access_key" {}

variable "bucket" {
  default = {
    name = "igvaquero-smarthome-web-content"
    coldbeer_key = "coldbeer"
  }
}

variable "upload_directory" {
  default = "../dist/"
}
