variable "aws_vpc" {
  type    = string
  default = "10.0.0.0/16"
}
variable "tags" {
  type    = string
  default = "my-app-vpc"
}
variable "zoneA" {
  type    = string
  default = "us-east-1a"
}
variable "zoneB" {
  type    = string
  default = "us-east-1b"
}
variable "zoneC" {
  type    = string
  default = "us-east-1c"
}
variable "aws_security_group" {
  type    = string
  default = "my-sg"
}
variable "key" {
  type    = string
  default = "Iankeypair"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ami" {
  type    = string
  default = "ami-06878d265978313ca"
}