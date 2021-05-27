export ECR_REPO_ARN=$(aws ecr describe-repositories --repository-names $ECS_TASK_REPO | jq -r .repositories[0].repositoryArn)
export S3_BUCKET_NAME=aws-file-drop-$AWS_ACCOUNT_ID

# IAM policies
envsubst < s3-task-role.json > s3-task-role-replaced.json
aws iam put-role-policy \
    --role-name ecsanywhereTaskRole \
    --policy-name ecsanywhereTaskPolicy \
    --policy-document file://s3-task-role-replaced.json

aws iam put-role-policy \
    --role-name ecsanywhereTaskExecutionRole \
    --policy-name ecsanywhereTaskPolicy \
    --policy-document file://s3-task-role-replaced.json    