
#!/bin/bash

# Update packages
sudo apt-get update

# Install Java 8 and Git
sudo apt-get install openjdk-8-jdk git

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins 

#Configure Jenkins
# echo "Enter your desired username, followed by [ENTER]:"
# read username
# sudo useradd -m -s /bin/bash $username
# echo "Enter a password for your $username account:"
# sudo passwd $username
# echo "Added user: $username"

# echo "Enter the desired Jenkins HTTP port, followed by [ENTER]:"
# read jenkins_port
# sudo sed -i "s/JENKINS_HTTP_PORT=8080/JENKINS_