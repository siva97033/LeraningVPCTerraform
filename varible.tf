variable "VPC" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "tags" {
  default = {
    env   = "Prod"
    owner = "siva"

  }
  description = "Additional resource tags"
  type        = map(string)
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "route1" {
  type        = string
  default     = "0.0.0.0/0"
  description = "public route table"
}

variable "route2" {
  type        = string
  default     = "0.0.0.0/0"
  description = "private route table"
}