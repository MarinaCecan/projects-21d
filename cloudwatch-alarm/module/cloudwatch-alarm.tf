data "aws_db_instance" "database" {
  db_instance_identifier = "postgres"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name                = var.alarm_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistics
  threshold                 = var.threshold
  alarm_description         = "This metric monitors RDS CPU utilization"
  alarm_actions             = [aws_sns_topic.sns_notify_slack_topic.arn]
  ok_actions                = [] #will not notify if everything is ok 
  insufficient_data_actions = [] #will not notify if insufficient data 

dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.database.id
  }
}
