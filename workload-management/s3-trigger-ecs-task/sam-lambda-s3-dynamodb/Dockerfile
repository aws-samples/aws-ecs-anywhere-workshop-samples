FROM public.ecr.aws/bitnami/golang as builder

WORKDIR /app/go-sample-app
COPY go.mod .

RUN export GOPROXY="direct"
RUN go env -w GOPRIVATE=*

COPY . .

RUN go mod download \
    && go mod download github.com/aws/aws-lambda-go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./out/go-sample-app main.go

FROM python:3.8.3-alpine

# Set necessary environmet variables needed for our image
RUN apk update && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

# Copy binary from build to main folder
COPY --from=builder /app/go-sample-app/out/go-sample-app /main

# Command to run when starting the container
CMD ["/main"]