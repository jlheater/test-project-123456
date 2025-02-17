# Installation Guide

## Overview

This guide walks through the process of setting up the build system and CI/CD pipeline for your project. Before starting, ensure you have met all [system requirements](requirements.md).

## Table of Contents
1. [Repository Setup](#repository-setup)
2. [Build System Installation](#build-system-installation)
3. [Docker Environment Setup](#docker-environment-setup)
4. [GitLab CI/CD Configuration](#gitlab-cicd-configuration)
5. [Verification](#verification)

## Repository Setup

1. Clone the template repository:
```bash
git clone https://gitlab.com/your-org/build-template.git your-project
cd your-project
```

2. Copy the build system files:
```bash
cp -r template/make/ .
cp template/Makefile .
```

3. Initialize the Docker configurations:
```bash
cp -r template/docker/ .
```

4. Set up GitLab CI/CD:
```bash
mkdir -p .gitlab/ci
cp -r template/.gitlab/ci/* .gitlab/ci/
cp template/.gitlab-ci.yml .
```

## Build System Installation

1. Configure the Makefile environment:
```bash
# Create build and dist directories
mkdir -p build dist

# Set up environment variables
export BUILD_DIR="$(pwd)/build"
export DIST_DIR="$(pwd)/dist"
```

2. Customize make/common.mk:
```bash
# Edit common variables
vim make/common.mk

# Example customization:
PROJECT_NAME="your-project-name"
DOCKER_REGISTRY="your-registry.com"
```

3. Configure language-specific makefiles:
   - Edit `make/cpp.mk` for C++ settings
   - Edit `make/python.mk` for Python settings

## Docker Environment Setup

1. Build the base image:
```bash
docker build -t your-registry.com/base:latest -f docker/base/Dockerfile .
```

2. Build language-specific images:
```bash
# C++ environment
docker build -t your-registry.com/cpp:latest -f docker/cpp/Dockerfile .

# Python environment
docker build -t your-registry.com/python:latest -f docker/python/Dockerfile .
```

3. Push images to registry:
```bash
docker push your-registry.com/base:latest
docker push your-registry.com/cpp:latest
docker push your-registry.com/python:latest
```

## GitLab CI/CD Configuration

1. Configure GitLab variables:
   - Navigate to Settings > CI/CD > Variables
   - Add required variables:
     ```
     CI_REGISTRY="your-registry.com"
     CI_REGISTRY_USER="your-username"
     CI_REGISTRY_PASSWORD="your-password"
     ```

2. Set up GitLab Runners:
   - Go to Settings > CI/CD > Runners
   - Register a new runner with Docker executor
   - Apply runner tags as needed

3. Customize CI/CD templates:
   - Edit `.gitlab/ci/base.gitlab-ci.yml` for common settings
   - Modify language-specific templates as needed

## Verification

1. Verify build system:
```bash
# Test Make targets
make build
make test
make package
make deploy
```

2. Verify Docker environments:
```bash
# Test C++ environment
docker run --rm your-registry.com/cpp:latest make --version

# Test Python environment
docker run --rm your-registry.com/python:latest python --version
```

3. Validate CI/CD pipeline:
```bash
# Commit and push changes
git add .
git commit -m "Initial setup"
git push origin main

# Check pipeline status in GitLab UI
```

## Contributing

### Adding New Language Support

1. Create language-specific makefile:
```bash
cp template/make/language.mk.template make/newlang.mk
```

2. Add Docker configuration:
```bash
cp -r template/docker/language/ docker/newlang/
```

3. Create CI/CD template:
```bash
cp template/.gitlab/ci/language.yml .gitlab/ci/newlang.yml
```

4. Update main configuration files:
   - Add language include to Makefile
   - Update .gitlab-ci.yml
   - Document new language support

## Troubleshooting

Common installation issues:

1. **Docker Build Fails**
   - Verify Docker daemon is running
   - Check network connectivity
   - Ensure sufficient disk space

2. **Make Errors**
   - Verify all required tools are installed
   - Check environment variables
   - Validate file permissions

3. **CI/CD Issues**
   - Confirm runner registration
   - Verify registry credentials
   - Check pipeline logs

For more detailed troubleshooting:
- See [Common Issues](../troubleshooting/common-issues.md)
- Check [Build Problems](../troubleshooting/build-problems.md)
- Review [Pipeline Debugging](../troubleshooting/pipeline-debugging.md)

## Next Steps

After successful installation:
1. Review the [Quick Start Guide](quickstart.md)
2. Explore [Build System Documentation](../build-system/overview.md)
3. Learn about [CI/CD Features](../ci-cd/pipeline-overview.md)
