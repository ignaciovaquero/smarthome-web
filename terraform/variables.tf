variable "secret_key" {
  type = string
}

variable "access_key" {
  type = string
}

variable "bucket_name" {
  type = string
  default = "igvaquero-smarthome-web-content"
}

variable "domain" {
  type = object({
    name = string
    subdomain = string
  })

  default = {
    name = "ignaciovaquero.com"
    subdomain = "smarthome"
  }
}

variable "upload_directory" {
  type = string
  default = "../dist/"
}
