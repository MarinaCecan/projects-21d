## Building CloudWatch Alarms using Terraform for monitoring CPU usage of RDS Database and notifying teams via Slack 

This is an example of how to create CloudWatch alarms that, when triggered, will send a message to SNS, which invokes a Lambda, which posts the message to a configured Slack webhook.

![](https://miro.medium.com/max/1200/1*_ulsaWF4LAmK0C30ziJWwA.png)

Amazon CloudWatch is a monitoring and observability service built for DevOps engineers, developers, site reliability engineers (SREs), IT managers, and product owners. CloudWatch provides you with data and actionable insights to monitor your applications, respond to system-wide performance changes, and optimize resource utilization. CloudWatch collects monitoring and operational data in the form of logs, metrics, and events. You get a unified view of operational health and gain complete visibility of your AWS resources, applications, and services running on AWS and on-premises. You can use CloudWatch to detect anomalous behavior in your environments, set alarms, visualize logs and metrics side by side, take automated actions, troubleshoot issues, and discover insights to keep your applications running smoothly.

To find out more information about CloudWatch, visit the AWS page: [AWS CloudWatch](https://aws.amazon.com/cloudwatch/)

Some examples of metrics that can be tracked by CloudWatch in an RDS Database:
- CPUUtilization
- DatabaseConnections
- FreeStorageSpace
- ReadLatency
- ReadThroughput

You can also send the logs to CloudWatch, if you need additional information on how to set this up, please refer to the following link: [CloudWatch Logs](https://www.youtube.com/watch?v=2s2xcwm8QrM)

Getting back to out initial mission, we will be creating a CloudWatch alarm that will be triggered by high CPU utilization of an RDS Database instance. The alarm will be tied to an SNS topic that will invoke a Lambda function to send notifications to Slack in a specific channel.

#### Retrieving the Slack Webhook URL 
1. First, you have to sign into your Slack workspace and access the following web page:
```
https://api.slack.com/
```
2. Choose Incoming Webhooks and create your Slack app ==> **From Scratch** option
3. Name the app and choose the workspace from the drop down menu. 
4. Navigate to the Incoming Webhooks and Activate Incoming Webhooks 
5. Then add new Webhook to workspace and choose the Slack Channel that you would like to receive notifications 
- The given link is the webhook which will help you connect with Slack

This link has all the necassary steps to retrieve the webhook: [Slack Webhook URL](https://www.youtube.com/watch?v=mCyf1gYkoMs&t=56s)

The following link will help you get a better understanding on how Lambda connects and sends notifications to a Slack channel: [Lambda sends notifications to Slack](https://www.youtube.com/watch?v=PsIwZmrUxYM)

#### Creating the CloudWatch Alarm, Lambda Function, SNS Topic & IAM using Terraform 

1. The creation of the RDS Database Instance, is not the focus of this demo, but here you can find information on how to build a Database instance using Terraform: [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)

You can also attach the CloudWatch alarm to any existing DB instances with the help of data source, all you need is the database identifier:

```
data "aws_db_instance" "database" {
  db_instance_identifier = "postgres"
}
```

For more information, please refer to the following link: [data_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance)

2. We will next create the CloudWatch alarm, this is the link that will help you to do so: [aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)

The Database is linked to the CloudWatch alarm with the help of the following Terraform code: 

```
dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds_instance.id
  }
```
In case you used data source, refer to the following method:

```
dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.database.id
  }
```

You can stipulate the actions of the alarm based on the state of the alarm in the example below, the alarm will only notify us if the state of the alarm is IN ALARM:

```
alarm_actions             = [aws_sns_topic.sns_notify_slack_topic.arn]
ok_actions                = [] #will not notify if everything is ok 
insufficient_data_actions = [] #will not notify if insufficient data  
```

3. The following step is to create an SNS topic & the topic subscription, which in our case will be "Lambda". 

```
resource "aws_sns_topic" "sns_notify_slack_topic" {
  name = "sns_notify_slack_topic"
}

resource "aws_sns_topic_subscription" "sns_notify_slack_subscription" {
  topic_arn = aws_sns_topic.sns_notify_slack_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_notify_slack_lambda.arn
}
```

Here is where you can find information on how to create these resources: [aws_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)
[aws_sns_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)

4. Next stept is to create a Lambda function using Python that will be able to send notifications to Slack when the CPU usage of the RDS Database reaches 80% and goes above it. This is the link where you can find information on how to create a Lambda function: [Getting started with Lambda](https://docs.aws.amazon.com/lambda/latest/dg/getting-started.html)

```
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
```
5. Create an IAM role, IAM policy and attach the policy to the role. You will need to attach the role to Lambda, in order to give it the necessary permissions.
[iam_permissions_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)

6. Create Lambda function using Terraform, here are some of the useful resources that will help you achieve that:
[lambda.tf GitHub repository with examples](https://github.com/ianrufus/BlogPosts/blob/master/TerraformCloudwatchAlarmToSlack/modules/sns_to_slack/lambda.tf)

Now the code needs to be packed up in a way that’s acceptable - a zip folder. We can do this through Terraform using data sources. That way you don’t have to remember to create a new zip every time you make a change:

```
data "null_data_source" "lambda_file" {
  inputs = {
    filename = "${path.module}/lambda.py"
  }
}
data "null_data_source" "lambda_archive" {
  inputs = {
    filename = "${path.module}/lambda.zip"
  }
}
data "archive_file" "sns_notify_slack_code" {
  type        = "zip"
  source_file = data.null_data_source.lambda_file.outputs.filename
  output_path = data.null_data_source.lambda_archive.outputs.filename
}
```
The first data source simply grabs a reference to the file, the second is a reference to the zip archive we’ll output. The third data source is the one that will actually create the archive for us, using the previous two values.

Now, we can finally create out Lambda function:

```
resource "aws_lambda_function" "sns_notify_slack_lambda" {
  filename         = data.archive_file.sns_notify_slack_code.output_path
  function_name    = "sns_notify_slack_lambda"
  role             = aws_iam_role.sns_notify_slack_lambda_role.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.sns_notify_slack_code.output_base64sha256
  runtime          = "python3.6"
  timeout          = 30

 environment {
    variables = {
      SLACK_WEBHOOK = var.slack_webhook
    }
}
}
```

Here we can see that the filename and source_code_hash are from the aforementioned data sources. The function_name is just what I want the function to be called in AWS - again using the application and environment variables for reusability.
The handler is the name of the function to execute in the code, which I’ve creatively called lambda_handler. It’s preceded by the name of the file, lambda because I’ve called my file lambda.py

7. Create a file called **vars.tf** that will contain all the variables to be reffered in the module. 

8. Create the Terraform module for the entire infrastructure. For more details on how to do so, you can refer to the following link: [terraform_module](https://www.terraform.io/language/modules/develop)

When your RDS Database CPU raises up to 80% or higher, you'll get a notification via Slack in the channel that you stipulated when retrieving the Webhook URL. This way, you can prevent risks related to your application from happening. 
