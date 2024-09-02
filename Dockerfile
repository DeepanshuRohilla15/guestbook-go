# Stage 1: Build the Go application
FROM golang:1.22-alpine

# Set the working directory
WORKDIR /app


COPY *.go ./

RUN go mod download

COPY . .

# Copy static files into the image
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css

RUN go build -o main main.go

EXPOSE 8080

CMD ["./main"]