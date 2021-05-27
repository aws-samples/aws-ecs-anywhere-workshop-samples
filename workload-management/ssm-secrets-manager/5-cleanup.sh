# Cleanup

# IAM detach
aws iam delete-role-policy --role-name ecsanywhereTaskExecutionRole --policy-name ecsanywhereTaskPolicy
aws iam delete-role-policy --role-name ecsanywhereTaskRole --policy-name ecsanywhereTaskPolicy

# Update Service
aws ecs update-service --cluster $CLUSTER_NAME --service $SSM_SERVICE --desired-count 0

# Delete the service
aws ecs delete-service --cluster $CLUSTER_NAME --service $SSM_SERVICE
aws ecr delete-repository --repository-name $REPONAME --force
aws secretsmanager delete-secret --secret-id SECRET_TEST_AWS
aws ssm delete-parameter --name PARAMETER_TEST_AWS
rm ssm-secrets-task-definition-replaced.json mycreds.json execution-role-replaced.json