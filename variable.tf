variable "region" {
  type    = string
  default = "us-west-2"
}

variable "execution_role_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}
