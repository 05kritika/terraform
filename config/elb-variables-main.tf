variable "security_groups" {
  description = "A list of security group IDs to assign to the ELB"
  type        = "list"
  default     = ["sg-b076f4cc"]
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the ELB"
  type        = "list"
  default     = ["subnet-f8cd98b0","subnet-3a3b305c"]
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
  default     = false
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining"
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  default     = 300
}

variable "listener" {
  description = "A list of listener blocks"
  type        = "list"
  default     = [
    {
        instance_port     = "80"
    instance_protocol = "TCP"
    lb_port           = "80"
    lb_protocol       = "TCP"
        }
  ]
}

variable "access_logs" {
  description = "An access logs block"
  type        = "list"
  default     = []
}

variable "health_check" {
  description = "A health check block"
  type        = "list"
  default     = [
        {
        target              = "TCP:80"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
        }
  ]
}
