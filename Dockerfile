# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build Stage
FROM golang:1.20 AS builder

# Install dependencies
RUN go get github.com/codegangsta/negroni \
           github.com/gorilla/mux \
           github.com/xyproto/simpleredis/v2

# Set the working directory
WORKDIR /app

# Copy the source code
COPY ./main.go .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final Stage
FROM scratch

# Set the working directory
WORKDIR /app

# Copy the binary from the build stage
COPY --from=builder /app/main .

# Copy additional files into the image
COPY ./public/index.html public/index.html
COPY ./public/script.js public/script.js
COPY ./public/style.css public/style.css

# Define the command to run the application
CMD ["/app/main"]

# Expose the port the app runs on
EXPOSE 3000
