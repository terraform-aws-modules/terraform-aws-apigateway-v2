#### Event bus

resource "aws_cloudwatch_event_rule" "heartbeat" {
  name                = "aws-ws-heartbeart"
  description         = "Ping connected Websocket clients"
  schedule_expression = "rate(1 minute)"
}

