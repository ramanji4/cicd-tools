#!/bin/bash

sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-21-openjdk -y

#resize disk from 20GB to 50GB
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/RootVG/rootVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /
xfs_growfs /var/tmp
xfs_growfs /var

sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins



# #!/bin/bash

# # Update packages
# dnf update -y

# # Install Java (required for Jenkins)
# dnf install java-17-amazon-corretto -y

# # Add Jenkins repo and import GPG key
# curl --silent --location https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key | sudo tee /etc/pki/rpm-gpg/jenkins.io-2023.key > /dev/null
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# curl --silent --location https://pkg.jenkins.io/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo > /dev/null

# # Install Jenkins
# dnf install jenkins -y

# # Enable and start Jenkins
# systemctl enable jenkins
# systemctl start jenkins

# # Install Nginx
# dnf install nginx -y

# # Configure Nginx reverse proxy
# cat <<EOF > /etc/nginx/conf.d/jenkins.conf
# server {
#     listen 80;
#     server_name jenkins.ram4india.space;

#     location / {
#         proxy_pass http://localhost:8080;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#     }
# }
# EOF

# # Enable and restart Nginx
# systemctl enable nginx
# systemctl restart nginx

# # Allow firewall (if using firewalld - optional)
# # firewall-cmd --permanent --add-port=80/tcp
# # firewall-cmd --permanent --add-port=8080/tcp
# # firewall-cmd --reload
