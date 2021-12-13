# Hello World Web Server
This is a repository using Terraform to create an instance with a block storage volume to create an index.html web page. The instance serves a webpage index.html using a 1 GB attached block storage volume residing on a valid partition table, mounted automatically upon boot.

## High Level Overview:

* Create AWS instance using Terraform.
* Create Webserver using Nginx.
* Attach EBS volume to EC2 instance.
* Verify webpage is displaying "Hello GR World" with Elastic IP address.
* Connect to instance via SSH.
* Create filesystem on EBS volume to store data.
* Confirm Ngninx web document is being served from Document Root directory. 

## Getting Started:

* Clone the repo, create a branch and intialize the repository.

```bash
git clone https://github.com/jcquiles/helloworld.git
git checkout -b <branch_name>
```
## Requirements:

* [Terraform v0.13.3](https://www.terraform.io/downloads.html)
* AWS credentials to build the terraform via command line
* `aws --version`
* `aws configure`
* **AWS key pair**

## Provisioning Webserver via Terraform:

* Terraform init: `terraform init`
* Terraform plan: `terraform plan`
* Terraform validate: `terraform validate`
* Terraform apply: `terraform apply`

```bash
➜  vm git:(chore/test) ✗ terraform apply -auto-approve
aws_ebs_volume.data_vol: Creating...
aws_security_group.webserver: Creating...
aws_security_group.webserver: Creation complete after 5s [id=sg-00b43e2276d58492d]
aws_instance.webserver: Creating...
aws_ebs_volume.data_vol: Still creating... [10s elapsed]
aws_ebs_volume.data_vol: Creation complete after 11s [id=vol-048056c9e05349c26]
aws_instance.webserver: Still creating... [10s elapsed]
aws_instance.webserver: Creation complete after 37s [id=i-05666aac626c3e07f]
aws_volume_attachment.hello_world: Creating...
aws_volume_attachment.hello_world: Still creating... [10s elapsed]
aws_volume_attachment.hello_world: Creation complete after 22s [id=vai-219113884]
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
# Dependencies during creation:

* provider **-->** security groups
* provider **-->** ebs volume
* instance **-->** elastic ip
* instance **-->** ebs volume attachment

# Connecting to your instance:

* Give user permission and remove all other permissions. `chmod 400 keypar.pem`
* Ssh into instance, for example: `ssh -i "hello-world.pem" ubuntu@ec2-35-174-73-43.compute-1.amazonaws.com`

# Creating filesystem on ebs volume to store data.

* Get yourself root rights. `sudo su -`
* View ebs volume of 1 GiB along with root volume. `fdisk -l`
* Create 1GB with fdisk, using following commands in order. `fdisk /dev/xvdh` **->** `n` **->** `p` **->** `1` **->** `w`
* Confirm the newly created partition. `lsblk`
* Format the partiton: `mkfs -t ext4 /dev/xvdh`
* View currently mounted files. `df-h`
* Create folder as mounting point. `mkdir mydata`
* Mount it with mount command. `mount /dev/xvdh /mydata/`
* Move insiade directory and use it to store data. `cd /mydata/`

# Move an Ngninx Web Root to New Location:

* [follow steps from this resource here](https://www.digitalocean.com/community/tutorials/how-to-move-an-nginx-web-root-to-a-new-location-on-ubuntu-16-04)

## Why use Terraform for IAC?

* Terraform is a powerful tool in your orchestration armory, it allows you to create, update, and control versioning of cloud infrastructure. Terraform provides benefits that include automated infrastructure management, lower deployment costs, and reduced provisioning time.

* Terraform lets you define infrastructure in config/code and will enable you to rebuild/change and track changes to infrastructure with ease.

## Pros and cons?

* Terraform is cloud agnostic.**+**
* Templating is possible to make the Terraform templates reusable.**+**
* Variables can be created to make the templates generic so that it can be reused.**+**
* Terraform doesn't have a GUI which would have made its use a lot easier.**-**
* There is no auto-rollback feature upon failure. **-**

