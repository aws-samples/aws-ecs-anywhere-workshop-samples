export CODE_COMMIT_REPO=ecs-anywhere-repo
export AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].OwnerId' --output text)
export AWS_DEFAULT_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')
export CODEPIPELINEBUCKET="codepipeline-$AWS_DEFAULT_REGION-$AWS_ACCOUNT_ID"
export ECR_REPO=cicdecsanysamplerepo

## ------------------------------------------------------------------------ ##
## Prep steps ##
## ------------------------------------------------------------------------ ##

# ECR
aws ecr create-repository --repository-name $ECR_REPO

# S3 Bucket
aws s3api create-bucket --bucket $CODEPIPELINEBUCKET --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION


# CodeCommit
aws codecommit create-repository --repository-name $CODE_COMMIT_REPO

# Roles and permissions 
export ECR_REPO_ARN=$(aws ecr describe-repositories --repository-names $ECR_REPO | jq -r .repositories[0].repositoryArn)

aws iam create-role --role-name ecs-a-code-build-role --assume-role-policy-document file://code-build-assume-role.json
envsubst < code-build-policy.json > code-build-policy-replaced.json
aws iam put-role-policy \
    --role-name ecs-a-code-build-role \
    --policy-name ecsanywherepolicy \
    --policy-document file://code-build-policy-replaced.json

aws iam create-role --role-name ecs-a-code-deploy-role --assume-role-policy-document file://code-build-assume-role.json
envsubst < code-deploy-policy.json > code-deploy-policy-replaced.json
aws iam put-role-policy \
    --role-name ecs-a-code-deploy-role \
    --policy-name ecsanywherepolicy \
    --policy-document file://code-deploy-policy-replaced.json

aws iam create-role --role-name ecs-a-code-pipeline-role --assume-role-policy-document file://code-pipeline-assume-role.json
envsubst < pipeline-policy.json > pipeline-policy-replaced.json
aws iam put-role-policy \
    --role-name ecs-a-code-pipeline-role \
    --policy-name ecsanywherepolicy \
    --policy-document file://pipeline-policy-replaced.json

# Push application to ECR
cd app
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker build -t $ECR_REPO .
docker tag $ECR_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPO:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPO:latest
cd ..

# Initial Task & Service Registration
envsubst < ecs-task.json > ecs-task-replaced.json && aws ecs register-task-definition --cli-input-json file://ecs-task-replaced.json && rm ecs-task-replaced.json
aws ecs create-service --cluster $CLUSTER_NAME --service-name cicd --launch-type EXTERNAL --task-definition cicd --desired-count 1

## ------------------------------------------------------------------------ ##
## Install steps ##
## ------------------------------------------------------------------------ ##


# Initial commit
./gitsetup.sh

# Provision
envsubst '$ECR_REPO, $CODE_COMMIT_REPO, $AWS_DEFAULT_REGION, $AWS_ACCOUNT_ID'  < build-project.json > build-project-replaced.json && aws codebuild create-project --cli-input-json file://build-project-replaced.json --service-role ecs-a-code-build-role && rm build-project-replaced.json
envsubst '$ECR_REPO, $CODE_COMMIT_REPO, $CLUSTER_NAME, $AWS_DEFAULT_REGION, $AWS_ACCOUNT_ID' < build-deploy.json > build-deploy-replaced.json && aws codebuild create-project --cli-input-json file://build-deploy-replaced.json --service-role ecs-a-code-deploy-role && rm build-deploy-replaced.json
envsubst < pipeline.json > pipeline-replaced.json && aws codepipeline create-pipeline --cli-input-json file://pipeline-replaced.json && rm pipeline-replaced.json

## ------------------------------------------------------------------------ ##
