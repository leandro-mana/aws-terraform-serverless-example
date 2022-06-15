output "hello_app_base_url" {
  description = "Base URL for API Gateway stage."
  value       = module.api_gw_stage_hello_app.base_url
}