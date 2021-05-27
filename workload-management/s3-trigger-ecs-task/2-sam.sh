export LAMBDA_REPO_URI=$(aws ecr describe-repositories --repository-names $LAMBDA_REPO | jq -r .repositories[0].repositoryUri)
cd sam-lambda-s3-dynamodb

# SAM build an deploy
sam build
sam deploy \
    --stack-name lambda-ecs-task-launcher \
    --image-repository $LAMBDA_REPO_URI \
    --region $AWS_DEFAULT_REGION \
    --parameter-overrides ECSClusterName=$CLUSTER_NAME TaskDefinition=$ECS_TASK_DEFINITION_NAME \
    --capabilities CAPABILITY_IAM

# Return back to root directory
cd ..