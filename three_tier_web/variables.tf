variable "region" {
  default = "ap-south-1"
}
variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "reflek_public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "reflek_private_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
