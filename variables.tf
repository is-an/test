variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "instance_name" {
  description = "EC2 인스턴스 Name 태그"
  type        = string
  default     = "Demo-Web"
}

variable "instance_type" {
  description = "EC2 인스턴스 유형"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair 이름"
  type        = string
  default     = "demo-terra-key"
}

variable "http_port" {
  description = "웹 서버 포트"
  type        = number
  default     = 80
}

variable "enable_http" {
  description = "HTTP 접근 허용 여부"
  type        = bool
  default     = true
}
