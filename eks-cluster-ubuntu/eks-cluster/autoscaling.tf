resource "aws_autoscaling_group" "asg_ec2" {
  name                = "eks_asg"
  capacity_rebalance  = true
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [aws_subnet.public-us-east-1a.id, aws_subnet.public-us-east-1b.id, aws_subnet.public-us-east-1c.id]

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_launch_template.eks_asg,
    aws_security_group.eksnodes_sg,
    aws_security_group_rule.node-ingress-cluster-inbound,
    aws_security_group_rule.cluster-egress-node-outbound
  ]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_asg.id
        version            = "$Latest"
      }
    }
  }
}

# resource "aws_autoscaling_policy" "scale_up_cpu_policy" {
#   name                   = "scale_up_cpu_policy"
#   autoscaling_group_name = aws_autoscaling_group.asg_ec2.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 300
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-up" {
#   alarm_name          = "custom-cpu-alarm"
#   alarm_description   = "alarm once cpu usage increases"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = 70

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.asg_ec2.name
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.scale_up_cpu_policy.arn]
# }

# resource "aws_autoscaling_policy" "scale_down_cpu_policy" {
#   name                   = "scale_down_cpu_policy"
#   autoscaling_group_name = aws_autoscaling_group.asg_ec2.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 300
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-down" {
#   alarm_name          = "custom-cpu-alarm-down"
#   alarm_description   = "alarm once cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = 20

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.asg_ec2.name
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.scale_down_cpu_policy.arn]
# }










