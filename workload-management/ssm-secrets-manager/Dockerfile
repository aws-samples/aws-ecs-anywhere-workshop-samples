FROM public.ecr.aws/bitnami/golang as builder

WORKDIR /app/ssm-secrets-manager
COPY go.mod .

RUN export GOPROXY="direct"
RUN go env -w GOPRIVATE=*
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./out/ssm-secrets-manager main.go

FROM scratch

# Copy binary from build to main folder
COPY --from=builder /app/ssm-secrets-manager/out/ssm-secrets-manager /main

EXPOSE 8080

# Command to run when starting the container
CMD ["/main"]