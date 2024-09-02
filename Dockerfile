# Stage 1: Build the Go application
FROM golang:1.21 AS builder

# Set the working directory
WORKDIR /app


COPY *.go ./


RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping


# Copy static files into the image
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css


CMD ["/docker-gs-ping"]

# Expose port 3000
EXPOSE 3000