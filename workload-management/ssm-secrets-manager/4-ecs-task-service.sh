# Set environment variables    
export PARAMETER_TEST_AWS=$(aws ssm get-parameter --name PARAMETER_TEST_AWS | jq -r .Parameter.ARN)
export SECRET_TEST_AWS=$(aws secretsmanager describe-secret --secret-id SECRET_TEST_AWS | jq -r .ARN)
export ECR_REPO=$(aws ecr describe-repositories --repository-names $REPONAME | jq -r .repositories[0].repositoryUri)
export ECR_REPO_ARN=$(aws ecr describe-repositories --repository-names $REPONAME | jq -r .repositories[0].repositoryArn)

# IAM
envsubst < execution-role.json > execution-role-replaced.json
aws iam put-role-policy \
    --role-name ecsanywhereTaskExecutionRole \
    --policy-name ecsanywhereTaskPolicy \
    --policy-document file://execution-role-replaced.json

# Task definition
envsubst < ssm-secrets-task-definition.json > ssm-secrets-task-definition-replaced.json
aws ecs register-task-definition --cli-input-json file://ssm-secrets-task-definition-replaced.json

# Service definition
aws ecs create-service --cluster $CLUSTER_NAME --service-name $SSM_SERVICE --launch-type EXTERNAL --task-definition $SSM_TASK_DEFINITION_NAME --desired-count 1