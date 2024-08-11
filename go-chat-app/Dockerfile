FROM golang:1.20-alpine

WORKDIR /app

# Copy go.mod and go.sum to the container
COPY go.mod go.sum ./

# Download dependencies (cached if no changes in go.mod and go.sum)
RUN go mod download

# Copy the rest of the application code to the container
COPY . .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["go", "run", "main.go"]
