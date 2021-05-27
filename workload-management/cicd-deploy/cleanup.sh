## ------------------------------------------------------------------------ ##
# Cleanup
## ------------------------------------------------------------------------ ##
export CODEPIPELINEBUCKET="codepipeline-$AWS_DEFAULT_REGION-$AWS_ACCOUNT_ID"
export CODE_COMMIT_REPO=ecs-anywhere-repo
export ECR_REPO=cicdecsanysamplerepo

# Pipelines
aws codepipeline  delete-pipeline --name EcsAnywhereCiCdPipeline

# CodeBuild
aws codebuild delete-project --name Ecsanywhere-build-cicd
aws codebuild delete-project --name Ecsanywhere-deploy-cicd

# Roles
aws iam delete-role-policy --role-name ecs-a-code-build-role --policy-name ecsanywherepolicy
aws iam delete-role-policy --role-name ecs-a-code-deploy-role --policy-name ecsanywherepolicy
aws iam delete-role-policy --role-name ecs-a-code-pipeline-role --policy-name ecsanywherepolicy

aws iam delete-role --role-name ecs-a-code-build-role
aws iam delete-role --role-name ecs-a-code-deploy-role
aws iam delete-role --role-name ecs-a-code-pipeline-role

# S3
aws s3 rm s3://$CODEPIPELINEBUCKET --recursive
aws s3api delete-bucket --bucket $CODEPIPELINEBUCKET

# Code Commit
aws codecommit delete-repository --repository-name $CODE_COMMIT_REPO

# ECR 
aws ecr delete-repository --repository-name $ECR_REPO --force

# ECS Service
aws ecs update-service --cluster $CLUSTER_NAME --service cicd --desired-count 0
aws ecs delete-service --cluster $CLUSTER_NAME --service cicd

rm -Rf app/gitrepo code-build-policy-replaced.json code-deploy-policy-replaced.json pipeline-policy-replaced.json