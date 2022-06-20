resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway-${var.lambda_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = var.principal
  source_arn    = "${var.source_arn}/*/*/*"
}