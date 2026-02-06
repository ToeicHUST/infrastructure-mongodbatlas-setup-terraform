variable "mongodb_atlas_org_id" {
  description = "ID của tổ chức trên MongoDB Atlas"
  type        = string
}

variable "mongodb_atlas_public_key" {
  type      = string
  sensitive = true
}

variable "mongodb_atlas_private_key" {
  type      = string
  sensitive = true
}

variable "project_names" {
  type    = list(string)
  default = ["ToeicHUST-DEV", "ToeicHUST-PROD"]
}

variable "mongodb_db_password" {
  description = "Mật khẩu cho database user admin"
  type        = string
  sensitive   = true
}