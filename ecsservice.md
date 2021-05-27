# ECS Service

## Launch ECS Service on the Remote Host

Next we will launch an ECS service on the remote host.

```bash
#Create a nginx ECS service
aws ecs create-service --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --launch-type EXTERNAL --task-definition nginx --desired-count 1

# Check the service status
aws ecs describe-services --cluster $CLUSTER_NAME --service $SERVICE_NAME

# Verify only 1 tasks is running and it's from the service
aws ecs list-tasks --cluster $CLUSTER_NAME
{
    "taskArns":["arn:aws:ecs:us-east-1:1234567890:task/test-ecs-anywhere/00984d9247b743de893616d438a8bdf9"]
}
```

Navigate to http://localhost:8080 and check if nginx is working

----

## Update the service

```bash
# Update the service such that the desired count is 0, which allows you to delete it
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --desired-count 0
```

----

## Delete the service

```bash
# Delete the service
aws ecs delete-service --cluster $CLUSTER_NAME --service $SERVICE_NAME
```
