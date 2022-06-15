resource "aws_apigatewayv2_integration" "api_gw_integration" {
  api_id             = var.api_gw_id
  integration_uri    = var.integration_uri
  integration_type   = var.integration_type
  integration_method = var.integration_method
}