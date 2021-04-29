terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28"
    }
  }

  backend "s3" {
    bucket = "igvaquero-terraform-state"
    key = "smarthome-web/state"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_iam_policy_document" "smarthome_web_s3_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket["name"]}/*"]
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "smarthome_web_bucket" {
  bucket = var.bucket["name"]
  acl = "public-read"
  policy = data.aws_iam_policy_document.smarthome_web_s3_policy.json

  website {
    index_document = "index.html"
  }
}

locals {
  mime_types = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    ico   = "image/x-icon"
    "png" = "image/png"
  }
}

resource "aws_s3_bucket_object" "coldbeer_content" {
  for_each = fileset(var.upload_directory, "**/*.*")

  bucket = aws_s3_bucket.smarthome_web_bucket.id
  key = replace(each.value, var.upload_directory, "")
  source = "${var.upload_directory}${each.value}"
  acl = "public-read"
  etag = filemd5("${var.upload_directory}${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

output "domain_name" {
  value = "http://${aws_s3_bucket.smarthome_web_bucket.website_endpoint}"
}
