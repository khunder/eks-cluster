module eks {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "system-work-group"
      instance_type                 = var.system_load_instance_type
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.system_worker_group_sg.id]
      asg_min_size         = var.autoscaling_system_count
      asg_desired_capacity = var.autoscaling_system_count
      asg_max_size         = var.autoscaling_system_count
      kubelet_extra_args = "--node-labels=instance-type=system-load --node-labels=instance-env=prod"
      tags = [{ "key" : "instance-type" , value: "system-load", "propagate_at_launch" = true }]
    },
    {
      name                          = "prod-worker-group"
      instance_type                 = var.work_load_instance_type
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.prod_worker_group_sg.id]
      asg_min_size         = var.prod_autoscaling_workload_count
      asg_desired_capacity = var.prod_autoscaling_workload_count
      asg_max_size         = var.prod_autoscaling_workload_count
      kubelet_extra_args = "--node-labels=instance-type=work-load --node-labels=instance-env=prod"
      tags = [{ "key" : "instance-type" , value: "work-load", "propagate_at_launch" = true }]
    },
  ]
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


#
