# Quick Start Guide

## Overview

This guide provides quick-start instructions for both developers and build engineers. For detailed setup, see the [Installation Guide](installation.md).

## Table of Contents
- [Developer Guide](#developer-guide)
  - [Project Setup](#project-setup)
  - [Common Tasks](#common-tasks)
  - [CI/CD Usage](#cicd-usage)
- [Build Engineer Guide](#build-engineer-guide)
  - [Docker Development](#docker-development)
  - [Runner Management](#runner-management)
  - [Advanced Configuration](#advanced-configuration)

## Developer Guide

### Project Setup

1. **Clone and Configure**
```bash
# Clone your project
git clone https://gitlab.com/your-org/your-project.git
cd your-project

# Verify Makefile exists
ls Makefile
```

2. **Configure Project Type**
```yaml
# .gitlab-ci.yml
variables:
  PROJECT_TYPE: cpp  # or 'python' for Python projects
```

### Common Tasks

1. **Basic Build Commands**
```bash
# Build project
make build

# Run tests
make test

# Create packages
make package

# Deploy
make deploy
```

2. **Project Structure Examples**

C++ Project:
```
my-cpp-project/
├── Makefile           # Generic targets (build, test, etc.)
├── CMakeLists.txt    # If using CMake
├── src/
│   └── main.cpp
└── tests/
    └── test_main.cpp
```

Python Project:
```
my-python-project/
├── Makefile          # Generic targets (build, test, etc.)
├── pyproject.toml    # For Python 3.11+ projects
├── setup.py         # For Python 3.9 projects
├── src/
│   └── main.py
└── tests/
    └── test_main.py
```

### CI/CD Usage

1. **Available Runners**
```yaml
# .gitlab-ci.yml example
variables:
  PROJECT_TYPE: cpp  # Automatically uses cpp runner

# Available runner tags:
# - base: Common tools
# - cpp: C++ development environment
# - python: Python development environment
```

2. **Manual Pipeline Triggers**
```bash
# Trigger via push
git push origin main

# Or via GitLab UI:
# CI/CD > Pipelines > Run Pipeline
```

3. **Common Pipeline Variables**
```yaml
variables:
  BUILD_TYPE: Debug
  PARALLEL_JOBS: "4"
```

4. **Running Tests**
```bash
# All tests
make test

# With specific arguments
make test TEST_FILTER="TestSuite.TestCase"  # C++ projects
make test PYTEST_ARGS="-k test_function"    # Python projects
```

## Build Engineer Guide

### Docker Development

1. **Local Environment Setup**
```bash
# Clone Docker configurations
git clone https://gitlab.com/your-org/docker-environments.git
cd docker-environments

# Set up dev environment
export DOCKER_REGISTRY="your-registry.com"
```

2. **Building Images Locally**
```bash
# Base image
cd base
docker build -t $DOCKER_REGISTRY/base:latest .

# Language-specific images
cd ../cpp
docker build -t $DOCKER_REGISTRY/cpp:latest .

cd ../python
docker build -t $DOCKER_REGISTRY/python:latest .
```

3. **Testing Environments**
```bash
# Test C++ environment
docker run --rm -v "$(pwd):/workspace" \
  $DOCKER_REGISTRY/cpp:latest make --version

# Test Python environment
docker run --rm -v "$(pwd):/workspace" \
  $DOCKER_REGISTRY/python:latest python --version
```

### Runner Management

1. **Runner Configuration**
```bash
# Register a runner with specific tags
gitlab-runner register \
  --url "https://gitlab.com/" \
  --registration-token "TOKEN" \
  --executor "docker" \
  --docker-image $DOCKER_REGISTRY/base:latest \
  --tag-list "base"
```

2. **AWS Configuration**
- Configure instance types for runners
- Set up auto-scaling groups
- Manage security groups

### Advanced Configuration

1. **Custom Build Arguments**
```dockerfile
# docker/cpp/Dockerfile
ARG CMAKE_VERSION=3.25
ARG GCC_VERSION=9
```

2. **Environment Optimizations**
```bash
# Build with cache mounting
docker build \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from $DOCKER_REGISTRY/cpp:latest \
  -t $DOCKER_REGISTRY/cpp:latest .
```

## Best Practices

### For Developers
- Use generic make targets (build, test, etc.)
- Specify PROJECT_TYPE in .gitlab-ci.yml
- Follow language-specific conventions
- Keep builds reproducible

### For Build Engineers
- Maintain minimal base images
- Optimize layer caching
- Monitor runner performance
- Document configuration changes

## Common Issues

1. **Build Problems**
```bash
# Clean and rebuild
make clean
make build
```

2. **Pipeline Issues**
- Check PROJECT_TYPE setting
- Verify runner availability
- Review pipeline logs

## Quick Reference

### Environment Variables
```bash
# Build configuration
export BUILD_TYPE=Release
export PARALLEL_JOBS=4
```

### Make Targets
| Target | Description |
|--------|-------------|
| `build` | Build project |
| `test` | Run tests |
| `package` | Create package |
| `deploy` | Deploy package |

### Available Runners
| Tag | Purpose |
|-----|----------|
| `base` | Common development tools |
| `cpp` | C++ development environment |
| `python` | Python development environment |

## Next Steps

### For Developers
1. Read [Build System Documentation](../build-system/overview.md)
2. Review [Pipeline Overview](../ci-cd/pipeline-overview.md)
3. Check [Troubleshooting Guide](../troubleshooting/common-issues.md)

### For Build Engineers
1. Study [Docker Configuration](../docker/base-image.md)
2. Review [Runner Setup](../ci-cd/job-templates.md)
3. Monitor [Performance Metrics](../ci-cd/parallel-execution.md)
