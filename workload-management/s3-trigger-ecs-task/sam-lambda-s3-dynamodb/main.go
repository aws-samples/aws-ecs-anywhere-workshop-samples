package main

import (
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"log"
	"os"
	"os/exec"
)

func handler(request events.S3Event) (events.APIGatewayProxyResponse, error) {
	copyCmd := fmt.Sprintf("aws ecs run-task --cluster %s --launch-type EXTERNAL "+
		"--overrides '{ \"containerOverrides\": [ { \"name\": \"%s\", \"environment\": [ { \"name\": \"S3_BUCKET_NAME\", \"value\": \"%s\" }, "+
		"{ \"name\": \"AWS_REGION\", \"value\": \"%s\"}, "+
		"{ \"name\": \"S3_KEY\", \"value\": \"%s\" }, { \"name\": \"STATUS_KEY\", \"value\": \"%s\" } ] } ] }' "+
		"--task-definition %s",
		os.Getenv("CLUSTERNAME"), os.Getenv("TASKDEFINITION"), request.Records[0].S3.Bucket.Name,
		os.Getenv("AWS_REGION"), request.Records[0].S3.Object.Key, request.Records[0].S3.Object.ETag,
		os.Getenv("TASKDEFINITION"))

	println("Generated command string " + copyCmd)
	cmd := exec.Command("sh", "-c", copyCmd)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()

	if err != nil {
		log.Println("Error while running the command " + err.Error())
		panic(err)
	}

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprintf("Launched external task with S3 parameters, %v", copyCmd),
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
