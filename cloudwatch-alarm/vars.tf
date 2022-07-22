variable alarm_name {
    default = "cpu_alarm"
}

variable comparison_operator {
    default = "GreaterThanOrEqualToThreshold"
}

variable evaluation_periods {
    default = 2
}

variable metric_name {
    default = "CPUUtilization"
}

variable namespace {
    default = "AWS/RDS"
}

variable period {
    default = 60
}

variable statistics {
    default = "Average"
}

variable threshold {
    default = 4 #for testing purposes
}

variable slack_webhook {
    default = "https://hooks.slack.com/services/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"
}
