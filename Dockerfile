FROM golang:1.23-bullseye AS build

ARG HUGO_VERSION=0.114.0

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libc6-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Build Hugo extended
ENV CGO_ENABLED=1
RUN go install -tags extended github.com/gohugoio/hugo@v${HUGO_VERSION}

# Final image
FROM debian:bullseye-slim

# Copy hugo binary from builder
COPY --from=build /go/bin/hugo /usr/local/bin/hugo

# Set default command
CMD ["hugo", "version"]