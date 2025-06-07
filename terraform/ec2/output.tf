output "lb_endpoint" {
  value = aws_lb.my_lb.dns_name
}

output "lb_dns" {
  value = aws_lb.my_lb.dns_name
}
