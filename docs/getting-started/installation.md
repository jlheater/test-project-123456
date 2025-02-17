# Installation Guide

## Table of Contents
- [Overview](#overview)
- [Developer Guide](#developer-guide)
  - [Prerequisites](#developer-prerequisites)
  - [Repository Setup](#repository-setup)
  - [Building and Testing](#building-and-testing)
  - [CI/CD Configuration](#cicd-configuration)
  - [Common Developer Tasks](#common-developer-tasks)
- [Build Engineer Guide](#build-engineer-guide)
  - [Prerequisites](#build-engineer-prerequisites)
  - [Docker Environment Setup](#docker-environment-setup)
  - [GitLab Runner Configuration](#gitlab-runner-configuration)
  - [Pipeline Template Management](#pipeline-template-management)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Overview

This guide is split into two main sections:
- **Developer Guide**: For day-to-day development operations
- **Build Engineer Guide**: For infrastructure and tooling updates

Before starting, ensure you have met all [system requirements](requirements.md).

## Developer Guide

### Developer Prerequisites
- Git 2.x or higher
- Make 4.x or higher
- Docker (for local testing)
- Language-specific tools:
  - C++: GCC/Clang, CMake (if using CMake)
  - Python: Python 3.9+ or 3.11+ (for new projects)

### Repository Setup

1. Clone your project repository:
```bash
git clone https://gitlab.com/your-org/your-project.git
cd your-project
```

2. Create a basic Makefile (if not exists):
```makefile
# Example Makefile
.PHONY: build test package deploy

build:
    # Your build commands here

test:
    # Your test commands here

package:
    # Your packaging commands here

deploy:
    # Your deployment commands here
```

3. Configure project type in .gitlab-ci.yml:
```yaml
variables:
  PROJECT_TYPE: cpp  # or 'python' for Python projects
```

### Building and Testing

```bash
# Build the project
make build

# Run tests
make test

# Create package
make package

# Deploy (if configured)
make deploy
```

### CI/CD Configuration

1. Basic .gitlab-ci.yml setup:
```yaml
include:
  - project: 'your-org/pipeline-templates'
    file: '/templates/base.yml'

variables:
  PROJECT_TYPE: cpp  # or 'python'

# Add any project-specific configurations below
```

2. Available GitLab runners:
- `base`: Common tools and utilities
- `cpp`: C++ development environment
- `python`: Python development environment

### Common Developer Tasks

1. Making code changes:
```bash
# Build and test locally
make build
make test

# Commit and push
git add .
git commit -m "Your changes"
git push origin main
```

2. Running specific tests:
```bash
# C++ projects
make test TEST_FILTER="TestSuite.TestCase"

# Python projects
make test PYTEST_ARGS="-k test_function"
```

## Build Engineer Guide

### Build Engineer Prerequisites
- All developer prerequisites
- Access to GitLab admin interface
- Docker registry access
- AWS access (for runner configuration)

### Docker Environment Setup

1. Build base image:
```bash
cd docker/base
docker build -t your-registry.com/base:latest .
docker push your-registry.com/base:latest
```

2. Build language images:
```bash
# C++ environment
cd ../cpp
docker build -t your-registry.com/cpp:latest .
docker push your-registry.com/cpp:latest

# Python environment
cd ../python
docker build -t your-registry.com/python:latest .
docker push your-registry.com/python:latest
```

3. Test environments locally:
```bash
# Verify C++ environment
docker run --rm your-registry.com/cpp:latest make --version

# Verify Python environment
docker run --rm your-registry.com/python:latest python --version
```

### GitLab Runner Configuration

1. Register runners:
```bash
gitlab-runner register \
  --url "https://gitlab.com/" \
  --registration-token "YOUR_TOKEN" \
  --executor "docker" \
  --docker-image your-registry.com/base:latest \
  --tag-list "base"
```

2. Configure runner tags:
- `base`: Base image with common tools
- `cpp`: C++ development environment
- `python`: Python development environment

3. AWS runner setup:
- Configure instance types
- Set up auto-scaling
- Configure networking and security

### Pipeline Template Management

1. Update base templates:
```bash
# Edit core pipeline templates
vim .gitlab/ci/base.yml

# Update language-specific templates
vim .gitlab/ci/cpp.yml
vim .gitlab/ci/python.yml
```

2. Test template changes:
- Create test projects
- Verify pipeline execution
- Monitor performance

## Troubleshooting

### Developer Issues
1. **Build Problems**
   - Verify Makefile targets
   - Check language-specific tools
   - Review [Build Problems](../troubleshooting/build-problems.md)

2. **Pipeline Issues**
   - Confirm PROJECT_TYPE setting
   - Check pipeline logs
   - Review [Pipeline Debugging](../troubleshooting/pipeline-debugging.md)

### Build Engineer Issues
1. **Docker Issues**
   - Verify registry access
   - Check image builds
   - Monitor resource usage

2. **Runner Problems**
   - Check runner registration
   - Verify AWS configuration
   - Monitor runner performance

For detailed troubleshooting:
- See [Common Issues](../troubleshooting/common-issues.md)
- Contact support team

## Next Steps

### For Developers
1. Review the [Quick Start Guide](quickstart.md)
2. Explore [Build System Documentation](../build-system/overview.md)
3. Set up your first project

### For Build Engineers
1. Review [Docker Environment](../docker/base-image.md#build-engineer-setup)
2. Explore [CI/CD Features](../ci-cd/pipeline-overview.md)
3. Monitor system performance
