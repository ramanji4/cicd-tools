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

  instance_type          = "t3.small"
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


resource "aws_key_pair" "tools" {
  key_name   = "tools"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXKFk/H9Q2cFbTaTQWiidoUdrH0QtLgQbpoBJKnWiGR ram83@Ramanjaneyulu"
}

module "SonarQube" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "SonarQube"
  ami = var.sonar_ami_id
  key_name = aws_key_pair.tools.key_name

  instance_type          = "t3.medium"
  vpc_security_group_ids = [var.sg_id]
  subnet_id              = var.public_subnet_id
  create_security_group  = false

  root_block_device = {
    delete_on_termination = true
    size                  = 30
    type                  = "gp3"
  }

  tags = {
    Name = "sonarqube"
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
    },
    {
      name    = "sonar-public"
      type    = "A"
      ttl     = 1
      records = [
        module.SonarQube.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "sonar-private"
      type    = "A"
      ttl     = 1
      records = [
        module.SonarQube.private_ip
      ]
      allow_overwrite = true
    }
  ]

}