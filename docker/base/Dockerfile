# Use a stable debian base
FROM debian:bullseye-slim

# Build arguments
ARG BUILD_TYPE=Release
ENV BUILD_TYPE=${BUILD_TYPE}

# Install common build tools and utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    make \
    pkg-config \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /workspace

# Add common environment variables
ENV PATH="/workspace/bin:${PATH}"
ENV BUILD_DIR=/workspace/build
ENV DIST_DIR=/workspace/dist

# Create build and dist directories
RUN mkdir -p ${BUILD_DIR} ${DIST_DIR}

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "make", "--version" ]

# Default command
CMD ["/bin/bash"]
