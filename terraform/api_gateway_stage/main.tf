resource "aws_apigatewayv2_stage" "stage" {
  api_id      = var.api_gw_id
  name        = var.name
  auto_deploy = var.auto_deploy

  access_log_settings {
    destination_arn = var.cw_log_group_arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  tags = var.tags
}