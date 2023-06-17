output "load_balancer_address" {
  value = "http://${aws_lb.web.dns_name}"
}
