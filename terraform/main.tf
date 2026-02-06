terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.16.0"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_public_key
  private_key = var.mongodb_atlas_private_key
}

# 1. Tạo 2 Project riêng biệt
resource "mongodbatlas_project" "projects" {
  for_each = toset(var.project_names)
  name     = each.value
  org_id   = var.mongodb_atlas_org_id
}

# 2. Tạo Cluster M0 (Free Tier) cho mỗi Project
resource "mongodbatlas_cluster" "free_clusters" {
  for_each   = mongodbatlas_project.projects
  project_id = each.value.id
  name       = "${each.key}-Cluster"

  # Cấu hình gói miễn phí
  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "AP_SOUTHEAST_1" 
  provider_instance_size_name = "M0"        # M0 là gói miễn phí
}

# 3. Mở khóa IP 0.0.0.0/0 cho cả 2 database
resource "mongodbatlas_project_ip_access_list" "allow_all" {
  for_each   = mongodbatlas_project.projects
  project_id = each.value.id
  cidr_block = "0.0.0.0/0"
  comment    = "Allow access from anywhere for development"
}


resource "mongodbatlas_database_user" "db_user" {
  for_each           = mongodbatlas_project.projects
  username           = "admin"
  password           = var.mongodb_db_password # <--- Đã sửa dòng này
  project_id         = each.value.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}