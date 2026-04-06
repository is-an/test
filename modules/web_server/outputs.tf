output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "퍼블릭 IP 주소"
  value       = aws_instance.web_server.public_ip
}

output "instance_state" {
  description = "인스턴스 상태"
  value       = aws_instance.web_server.instance_state
}

output "web_server_url" {
  description = "웹 서버 URL"
  value       = var.enable_http ? "http://${aws_instance.web_server.public_ip}:${var.http_port}" : ""
}
