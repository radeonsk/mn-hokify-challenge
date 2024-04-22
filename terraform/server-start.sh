#!/bin/sh

# Install docker, unzip and jq
sudo apt update
sudo apt install docker.io unzip jq -y

# Install AWS CLI v2
cd /tmp/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install and start Github self-hosted runner
cd /home/ubuntu
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.315.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.315.0.tar.gz
sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
sudo -u ubuntu ./config.sh --url https://github.com/radeonsk/mn-hokify-challenge --token $(aws ssm get-parameter --name github-token --with-decryption | jq -r '.Parameter.Value') --unattended
sudo ./svc.sh install
sudo ./svc.sh start