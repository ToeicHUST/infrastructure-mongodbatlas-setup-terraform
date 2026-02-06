output "connection_strings" {
  value = {
    for k, v in mongodbatlas_cluster.free_clusters : k => v.connection_strings[0].standard_srv
  }
}