export AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].OwnerId' --output text)
export REPONAME=go-sample-ssm-secrets-repo
export SSM_TASK_DEFINITION_NAME=ssmwithsecrets
export SSM_SERVICE=ssmService