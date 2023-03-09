module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.31.0"

  namespace = "kube-wp"
  name      = "wp-content"
  region    = "eu-central-1"
  vpc_id    = module.vpc.vpc_id
  subnets   = module.vpc.private_subnets
  security_group_rules = [
    {
      "cidr_blocks" : ["0.0.0.0/0"],
      "description" : "Allow all outbound traffic",
      "from_port" : 0,
      "protocol" : "-1",
      "to_port" : 65535,
      "type" : "egress"
    },
    {
      "cidr_blocks" : ["10.0.0.0/16"],
      "description" : "Allow all traffic from within the VPC",
      "from_port" : 0,
      "protocol" : "-1",
      "to_port" : 65535,
      "type" : "ingress"
    },
  ]
}