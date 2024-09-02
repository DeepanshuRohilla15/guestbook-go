# Stage 1: Build the Go application
FROM golang:1.20 AS builder

# Install required Go packages
RUN go get github.com/codegangsta/negroni \
           github.com/gorilla/mux \
           github.com/xyproto/simpleredis/v2

# Set the working directory
WORKDIR /app


# Download Go module dependencies
RUN go mod download

# Copy the source code into the container
COPY ./main.go .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Create the final minimal image
FROM scratch

# Set the working directory
WORKDIR /app

# Copy the binary from the build stage
COPY --from=builder /app/main .

# Copy static files into the image
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css

# Define the command to run the application
CMD ["/app/main"]

# Expose port 3000
EXPOSE 3000