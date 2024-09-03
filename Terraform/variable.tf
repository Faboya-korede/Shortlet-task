variable "project_id" {
  type      = string
  sensitive = true


}

variable "region" {
  type      = string
  sensitive = true

}

variable "cluster_location" {
  type      = string
  sensitive = true

}

variable "config_map_values" {
  type = map(string)


}