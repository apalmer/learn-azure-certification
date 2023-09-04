variable "name" {
  type = string
  description = "Network Detective Appliance"
  default = "netective"
}

variable "resource_group_name" {
  type = string
  description = "Resource Group of Netective"
  default = "rg-netective"
}

variable "location" {
    type = string
    description = "Region of Netective"
    default = "East US"
}

variable "subnet_id" {
  type = string
  description = "Subnet to attach Netective to"
}

variable "tags" {
  type = map(string)
  description = "Tags to add to Netective"
}