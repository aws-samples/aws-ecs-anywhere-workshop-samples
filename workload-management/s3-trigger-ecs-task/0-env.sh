# Set environment variables
export AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].OwnerId' --output text)
export LAMBDA_REPO=s3-lambda-dynamodb-trigger
export ECS_TASK_REPO=ecs-task-s3-process-repo
export ECS_TASK_DEFINITION_NAME=ECSS3Task
export AWS_DEFAULT_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')