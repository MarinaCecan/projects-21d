#!/usr/bin/python3.6
import urllib3
import json

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    
    data = {"text": "Alarm! High Utilization of CPU on RDS!"}
    r = http.request("POST",
    "https://hooks.slack.com/services/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",
    body = json.dumps(data),
    headers = {"Content-Type": "application/json"})
    
    return {
        'statusCode':200,
        'body': json.dumps("Alarm! High Utilization of CPU on RDS!")
    }
