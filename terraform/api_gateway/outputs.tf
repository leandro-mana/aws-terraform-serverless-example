output "execution_arn" {
  value = aws_apigatewayv2_api.api_gw.execution_arn
}

output "id" {
  value = aws_apigatewayv2_api.api_gw.id
}

output "cw_log_group_arn" {
  value = aws_cloudwatch_log_group.cloudwatch_log_group.arn
}