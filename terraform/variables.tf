variable "parent_domain" {
  description = "Domain from which we can delagate a subdomain"
}

variable "subdomain" {
  description = "Subdomain for tools"
}

variable "le_email" {
  description = "Email for LE registration"
}

variable "le_account_key_size" {
  description = "Subdomain for tools"
  default     = "4096"
}
