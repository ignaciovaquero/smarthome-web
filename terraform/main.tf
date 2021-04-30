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
  region = "us-east-1" # CloudFront expects ACM resources in us-east-1 region only
  access_key = var.access_key
  secret_key = var.secret_key
  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

locals {
  domain_name = "ivaquero.es"
  subdomain   = "smarthome"
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

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${local.subdomain}.${local.domain_name}"]

  comment             = "SmartHome Web App"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_100"

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "only SmartHome Web App can access"
  }

  logging_config = {
    bucket = module.log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    s3_one = {
      domain_name = module.s3_one.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one" # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods  = ["HEAD", "GET", "OPTIONS"]
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
      cached_methods  = ["HEAD", "GET", "OPTIONS"]
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["ES"]
  }

}

######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name               = "${local.subdomain}.${local.domain_name}"
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
}

#############
# S3 buckets
#############

data "aws_canonical_user_id" "current" {}

module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket        = var.bucket["name"]
  force_destroy = true
}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket = "logs-${random_pet.this.id}"
  acl    = null
  grant = [{
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = data.aws_canonical_user_id.current.id
    }, {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
    # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }]
  force_destroy = true
}

##########
# Route53
##########

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = module.cdn.cloudfront_distribution_domain_name
        zone_id = module.cdn.cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}

###########################
# Origin Access Identities
###########################
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_one.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_one.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

########
# Extra
########

resource "random_pet" "this" {
  length = 2
}

resource "aws_s3_bucket_object" "smarthome_content" {
  for_each = fileset(var.upload_directory, "**/*.*")

  bucket = module.s3_one.s3_bucket_id
  key = replace(each.value, var.upload_directory, "")
  source = "${var.upload_directory}${each.value}"
  acl = "public-read"
  etag = filemd5("${var.upload_directory}${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

output "domain_name" {
  value = module.records.route53_record_name
}
