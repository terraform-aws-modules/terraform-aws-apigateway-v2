module "wrapper" {
  source = "../"

  for_each = var.items

  api_key_selection_expression                       = try(each.value.api_key_selection_expression, var.defaults.api_key_selection_expression, null)
  api_mapping_key                                    = try(each.value.api_mapping_key, var.defaults.api_mapping_key, null)
  api_version                                        = try(each.value.api_version, var.defaults.api_version, null)
  authorizers                                        = try(each.value.authorizers, var.defaults.authorizers, {})
  body                                               = try(each.value.body, var.defaults.body, null)
  cors_configuration                                 = try(each.value.cors_configuration, var.defaults.cors_configuration, {})
  create                                             = try(each.value.create, var.defaults.create, true)
  create_certificate                                 = try(each.value.create_certificate, var.defaults.create_certificate, false)
  create_domain_name                                 = try(each.value.create_domain_name, var.defaults.create_domain_name, false)
  create_domain_records                              = try(each.value.create_domain_records, var.defaults.create_domain_records, false)
  create_routes_and_integrations                     = try(each.value.create_routes_and_integrations, var.defaults.create_routes_and_integrations, true)
  create_stage                                       = try(each.value.create_stage, var.defaults.create_stage, true)
  credentials_arn                                    = try(each.value.credentials_arn, var.defaults.credentials_arn, null)
  description                                        = try(each.value.description, var.defaults.description, null)
  disable_execute_api_endpoint                       = try(each.value.disable_execute_api_endpoint, var.defaults.disable_execute_api_endpoint, null)
  domain_name                                        = try(each.value.domain_name, var.defaults.domain_name, null)
  domain_name_certificate_arn                        = try(each.value.domain_name_certificate_arn, var.defaults.domain_name_certificate_arn, null)
  domain_name_ownership_verification_certificate_arn = try(each.value.domain_name_ownership_verification_certificate_arn, var.defaults.domain_name_ownership_verification_certificate_arn, null)
  fail_on_warnings                                   = try(each.value.fail_on_warnings, var.defaults.fail_on_warnings, null)
  integrations                                       = try(each.value.integrations, var.defaults.integrations, {})
  mutual_tls_authentication                          = try(each.value.mutual_tls_authentication, var.defaults.mutual_tls_authentication, {})
  name                                               = try(each.value.name, var.defaults.name, "")
  protocol_type                                      = try(each.value.protocol_type, var.defaults.protocol_type, "HTTP")
  route_key                                          = try(each.value.route_key, var.defaults.route_key, null)
  route_selection_expression                         = try(each.value.route_selection_expression, var.defaults.route_selection_expression, null)
  stage_access_log_settings                          = try(each.value.stage_access_log_settings, var.defaults.stage_access_log_settings, {})
  stage_client_certificate_id                        = try(each.value.stage_client_certificate_id, var.defaults.stage_client_certificate_id, null)
  stage_default_route_settings                       = try(each.value.stage_default_route_settings, var.defaults.stage_default_route_settings, {})
  stage_description                                  = try(each.value.stage_description, var.defaults.stage_description, null)
  stage_name                                         = try(each.value.stage_name, var.defaults.stage_name, "$default")
  stage_tags                                         = try(each.value.stage_tags, var.defaults.stage_tags, {})
  stage_variables                                    = try(each.value.stage_variables, var.defaults.stage_variables, {})
  subdomains                                         = try(each.value.subdomains, var.defaults.subdomains, [])
  tags                                               = try(each.value.tags, var.defaults.tags, {})
  target                                             = try(each.value.target, var.defaults.target, null)
  vpc_link_tags                                      = try(each.value.vpc_link_tags, var.defaults.vpc_link_tags, {})
  vpc_links                                          = try(each.value.vpc_links, var.defaults.vpc_links, {})
}
