module "Jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "Jenkins"
  ami = data.aws_ami.DevOps-Practice.id

  instance_type          = "t3.small"
  vpc_security_group_ids = [var.sg_id]
  subnet_id              = var.public_subnet_id
  user_data              = file("jenkins.sh")
  create_security_group  = false

  root_block_device = {
    delete_on_termination = true
    size                  = 50
    type                  = "gp3"
  }

  tags = {
    Name = "jenkins"
  }
}


module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "Jenkins_agent"
  ami = data.aws_ami.DevOps-Practice.id

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id]
  subnet_id              = var.public_subnet_id
  user_data              = file("jenkins_agent.sh")
  create_security_group  = false

  root_block_device = {
    delete_on_termination = true
    size                  = 50
    type                  = "gp3"
  }

  tags = {
    Name = "jenkins_agent"
  }
}




module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.Jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins_agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
      allow_overwrite = true
    }
  ]

}