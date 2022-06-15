resource "aws_apigatewayv2_route" "api_gw_route" {
  api_id    = var.api_gw_id
  route_key = var.route_key
  target    = var.target
}