# Installing Terraform on Win
# Installing Atom Editor

# Terraform Provider
  - AWS
    - terraform
      - Access Key & Secret Key
      - $ aws configure

- Terraform Script to define provider
    - Extension of terraform scripts .tf
    - terraform block
    - configure the region

- Terraform Commands:
  - $ terraform init
  - $ terraform plan
  - $ terraform apply
  - $ terraform destroy

### User Data:

  #!/bin/bash
  yum update -y
  yum install httpd -y
  systemctl start httpd
  systemctl enable httpd
  TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
  EC2_AVAIL_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
  echo "<h1>Hello World from $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
