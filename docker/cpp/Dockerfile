# Use our base image
FROM registry.gitlab.com/${CI_PROJECT_PATH}/base:latest

# Build arguments
ARG CMAKE_VERSION=3.25.1
ARG BUILD_TYPE=Release
ENV BUILD_TYPE=${BUILD_TYPE}

# Install C++ specific tools and libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    ccache \
    clang \
    clang-format \
    clang-tidy \
    cmake \
    cppcheck \
    g++ \
    gcovr \
    gdb \
    libboost-all-dev \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Configure ccache
ENV CCACHE_DIR=/ccache
ENV PATH="/usr/lib/ccache:${PATH}"
RUN mkdir -p ${CCACHE_DIR}

# Set up CMake environment variables
ENV CMAKE_BUILD_TYPE=${BUILD_TYPE}
ENV CMAKE_EXPORT_COMPILE_COMMANDS=ON
ENV CMAKE_GENERATOR="Ninja"

# Default working directory for C++ projects
WORKDIR /workspace/cpp

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "g++", "--version" ]

# Default command
CMD ["/bin/bash"]
