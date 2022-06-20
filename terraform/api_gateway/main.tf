resource "aws_apigatewayv2_api" "api_gw" {
  name          = var.name
  protocol_type = var.protocol_type
  tags          = var.tags
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.api_gw.name}"
  retention_in_days = var.log_retention_in_days
}
