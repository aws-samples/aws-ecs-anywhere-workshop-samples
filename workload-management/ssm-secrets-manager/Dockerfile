FROM public.ecr.aws/bitnami/golang as builder

RUN apt-get -y update && apt-get -y install git

WORKDIR /app/ssm-secrets-manager
COPY go.mod .

RUN export GOPROXY="direct"
RUN go env -w GOPRIVATE=*
RUN go mod download

COPY ../.. .
RUN go build -o ./out/ssm-secrets-manager main.go

FROM public.ecr.aws/bitnami/golang

# Set necessary environmet variables needed for our image
RUN apt-get -y update && apt-get -y install \
        python3 \
        python3-pip \
        ca-certificates \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy binary from build to main folder
COPY --from=builder /app/ssm-secrets-manager/out/ssm-secrets-manager /main

EXPOSE 8080

# Command to run when starting the container
CMD ["/main"]