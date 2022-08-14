#Project Requirement:

Create VPC
Create 2 subnet a. Public subnet : Enable internet access : Enable port 80, 22 b. Private Subnet : Shouldn’t able to access the internet
Create 2 EC2 : a. One in public subnet b. One in private subnet
Change hostname for both the server as follows: a. public e.g. nikhilpublic b. private e.g. nikhilprivate
Create users in both the server with an access to root
Install webserver in both the machine
Private machine should be only accessed via public machine (hint access AWS IAM role)
Create s3 bucket with version control
Create static website to be host on AWS s3 bucket
When accessed: (Search on revers proxy) http://public_machineip:80  should point to public webserver http://public_machineip:80/private --> should point to private webserver http://public_machineip:80/s3website --> should point to s3 static website created above
Monitor instance with Nagios and Grafana.
  Process of creation:

Run Jenkins pipeline to create all infrastructure & configuration
All resource should be created with terraform
All configurations should be performed using ansible
All code should be present in git hub repository
Jenkins should have option to rollback the code on new infrastructure
No credentials are hardcoded
All EC2 instance should be spot instance only
All configuration changes need to be approved in Jenkins prior changes applied using office365 smtp
Create 3 users in Jenkins, a. One who can create, update & delete pipeline b. One who can just run the pipeline c. One administrator (shouldn’t be default)
