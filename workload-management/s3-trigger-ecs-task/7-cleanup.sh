# IAM detach
aws iam delete-role-policy --role-name ecsanywhereTaskRole --policy-name ecsanywhereTaskPolicy

# Clear S3 bucket
aws s3 rm --recursive s3://aws-file-drop-$AWS_ACCOUNT_ID

# Delete cloudformation stack
aws cloudformation delete-stack --stack-name lambda-ecs-task-launcher

# Delete ECR repositories
aws ecr delete-repository --repository-name $LAMBDA_REPO --force
aws ecr delete-repository --repository-name $ECS_TASK_REPO --force

# Cleanup temp files
rm ecs-task-replaced.json s3-task-role-replaced.json