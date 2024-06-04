################################################################################
# Migrations: v4.0.0 -> v5.0.0
################################################################################

moved {
  from = aws_apigatewayv2_stage.default
  to   = aws_apigatewayv2_stage.this
}

moved {
  from = aws_cloudwatch_log_group.this[0]
  to   = aws_cloudwatch_log_group.this["this"]
}
