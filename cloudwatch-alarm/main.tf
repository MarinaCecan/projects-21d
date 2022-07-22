module "cloudwatch-alarm" {
  source               = "./module"
  alarm_name           = var.alarm_name
  comparison_operator  = var.comparison_operator
  evaluation_periods   = var.evaluation_periods
  metric_name          = var.metric_name
  namespace            = var.namespace
  period               = var.period
  statistics           = var.statistics
  threshold            = var.threshold

  slack_webhook = var.slack_webhook
}
