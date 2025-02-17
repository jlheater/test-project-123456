# Use our base image
FROM registry.gitlab.com/${CI_PROJECT_PATH}/base:latest

# Build arguments
ARG PYTHON_VERSION=3.9
ARG BUILD_TYPE=Release
ENV BUILD_TYPE=${BUILD_TYPE}

# Install Python and development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    python3-wheel \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python and pip
RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/local/bin/python3 && \
    ln -sf /usr/bin/python${PYTHON_VERSION} /usr/local/bin/python

# Set up virtual environment
ENV VIRTUAL_ENV=/workspace/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install common Python packages
RUN pip install --no-cache-dir \
    black \
    flake8 \
    mypy \
    pylint \
    pytest \
    pytest-cov \
    tox

# Set up Python specific environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1

# Default working directory for Python projects
WORKDIR /workspace/python

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "python", "--version" ]

# Default command
CMD ["/bin/bash"]
