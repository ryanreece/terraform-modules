variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "inbound_rules" {
  description = "List of inbound rules"
  type = list(object({
    protocol         = string
    port_range       = optional(string)
    source_addresses = list(string)
  }))
}

variable "outbound_rules" {
  description = "List of outbound rules"
  type = list(object({
    protocol          = string
    port_range        = optional(string)
    destination_addresses = list(string)
  }))
}

variable "tags" {
  description = "List of tags to apply to the firewall"
  type        = list(string)
  default     = []
}
