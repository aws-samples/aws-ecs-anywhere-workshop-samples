#! /bin/bash
export ACTIVATION_ID=123456789-49c6-4286-b9d4-2b08d9ef74d0
export ACTIVATION_CODE=abcdefghijklmnop
export CLUSTER_NAME=test-ecs-anywhere

# Pre-Prod Only Setup 
mkdir /tmp/ssm
echo '{"Ssm": {"Endpoint": "https://sonic.us-east-1.amazonaws.com/ssm"}}' > /tmp/ssm/amazon-ssm-agent.json 
sudo mkdir -p /etc/amazon/ssm 
sudo mv /tmp/ssm/amazon-ssm-agent.json /etc/amazon/ssm/amazon-ssm-agent.json 
rmdir /tmp/ssm 

# Download the install Script 
curl -o "ecs-anywhere-install.sh" "https://amazon-ecs-agent-packages-preview.s3.us-east-1.amazonaws.com/ecs-anywhere-install.sh"
sudo chmod +x ecs-anywhere-install.sh

# (Optional) Check integrity of the shell script
curl -o "ecs-anywhere-install.sh.sha256" "https://amazon-ecs-agent-packages-preview.s3.us-east-1.amazonaws.com/ecs-anywhere-install.sh.sha256"
sha256sum -c ecs-anywhere-install.sh.sha256

# Run the install Script 
sudo ./ecs-anywhere-install.sh --region us-east-1 --cluster $CLUSTER_NAME --activation-id $ACTIVATION_ID --activation-code $ACTIVATION_CODE --ecs-endpoint https://ecs-zeta.amazonaws.com