# Register task
export ECR_REPO=$(aws ecr describe-repositories --repository-names $ECS_TASK_REPO | jq -r .repositories[0].repositoryUri)
envsubst < ecs-task.json > ecs-task-replaced.json
aws ecs register-task-definition --cli-input-json file://ecs-task-replaced.json