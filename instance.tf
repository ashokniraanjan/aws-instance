data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Creating ec2 instance

resource "aws_instance" "terraform-ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "terraform-first-instance"
  }


  user_data = file("${path.module}/script.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }

  # provisioner "file" {
  #   source      = "readme.md"
  #   destination = "/tmp/readme.md"
  # }

  # provisioner "file" {
  #   content     = "This is a test file"
  #   destination = "/tmp/content.md"
  # }

  provisioner "local-exec" {
    command = "set > env.txt"
    environment = {
      envname = "envvalue"
    }
  }

  # provisioner "local-exec" {
  #   command = "echo 'At create'"
  # }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "echo 'At destroy'"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "ifconfig > /tmp/ifconfig.output",
  #     "echo 'Hello Ashok' > /tmp/test.txt"
  #   ]
  # }

  # provisioner "remote-exec" {
  #   script = "./testscript.sh"
  # }
}