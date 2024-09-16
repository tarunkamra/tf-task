
variable "project_id" {
  type = string
}

variable "region" {
  description = "Location for load balancer and Cloud Run resources"
  default     = "us-central1"
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = false
}

# variable "domain" {
#   description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
#   type        = string
# }

variable "lb_name" {
  description = "Name for load balancer and associated resources"
  default     = "tf-cr-lb"
}

variable "db_user" {
  type = string
}

variable "db_pass" {
  type = string

}

variable "db_name" {
  type = string
}