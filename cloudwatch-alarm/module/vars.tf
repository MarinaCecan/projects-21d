variable  slack_webhook {
    default = "https://hooks.slack.com/services/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"
}

variable alarm_name {
    type = string 
}

variable comparison_operator {
    type = string
}

variable evaluation_periods {
    type = number 
}

variable metric_name {
    type = string
}

variable namespace {
    type = string
}

variable period {
    type = number
}

variable statistics {
    type = string
}

variable threshold {
    type = number
}
