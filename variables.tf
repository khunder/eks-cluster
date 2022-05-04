
variable "prod_autoscaling_workload_count" {
  description = "Count to be used for autoscaling group"
  type        = number
  default     = 1
}

variable "autoscaling_system_count" {
  description = "Count to be used for system autoscaling group"
  type        = number
  default     = 1
}

variable "work_load_instance_type" {
  description = "Instance type for prod workload machines"
  type        = string
  default     = "c5ad.large"
}

variable "system_load_instance_type" {
  description = "Instance type for workload machines"
  type        = string
  default     = "t3.medium"
}
