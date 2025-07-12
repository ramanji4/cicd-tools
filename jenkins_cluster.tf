module "Jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "Jenkins"
  ami = data.aws_ami.DevOps-Practice.id

  instance_type          = "t3.small"
  vpc_security_group_ids = [var.sg_id]
  subnet_id              = var.public_subnet_id
  user_data              = file("jenkins.sh")
  create_security_group  = false

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

  tags = {
    Name = "jenkins_agent"
  }
}