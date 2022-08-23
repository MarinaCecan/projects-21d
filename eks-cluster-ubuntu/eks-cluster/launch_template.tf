data "aws_ssm_parameter" "image_id" {
  name = "/aws/service/eks/optimized-ami/1.21/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_asg" {
  image_id               = data.aws_ssm_parameter.image_id.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  name_prefix            = "eks-cluster-worker-"
  vpc_security_group_ids = [aws_security_group.eksnodes_sg.id]
  depends_on = [
    aws_iam_role.eksnodes_role
  ]

  iam_instance_profile {
    arn = aws_iam_instance_profile.eksnodes_profile.arn
  }
  user_data = base64encode(<<EOF
  #!/bin/bash
  set -o xtrace
  /etc/eks/bootstrap.sh ${var.cluster_name}
  EOF
  )

  tag_specifications {
    resource_type = "instance"


    tags = {
      Name                                        = "EKS-worker"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      propagate_at_launch                         = true
    }
  }
}
