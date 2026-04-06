module "web_server" {
  source        = "./modules/web_server"
  instance_name = var.instance_name
  instance_type = var.instance_type
  key_name      = var.key_name
  http_port     = var.http_port
  enable_http   = var.enable_http
}
