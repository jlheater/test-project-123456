# Quick Start Guide

## Overview

This guide provides a quick introduction to using the build system and CI/CD pipeline with practical examples. For detailed setup instructions, see the [Installation Guide](installation.md).

## Quick Setup

### 1. Clone and Configure
```bash
# Clone your project
git clone https://gitlab.com/your-org/your-project.git
cd your-project

# Set up environment
export BUILD_DIR="$(pwd)/build"
export DIST_DIR="$(pwd)/dist"
```

### 2. Basic Build Commands
```bash
# Build everything
make build

# Run all tests
make test

# Create packages
make package

# Deploy
make deploy
```

## Common Use Cases

### C++ Project

1. **Build a C++ Project**
```bash
# Build C++ components
make .build-cpp

# Run C++ tests
make .test-cpp

# Package C++ artifacts
make .package-cpp
```

2. **Example C++ Project Structure**
```
my-cpp-project/
├── CMakeLists.txt
├── src/
│   └── main.cpp
└── tests/
    └── test_main.cpp
```

### Python Project

1. **Build a Python Project**
```bash
# Set up Python environment
make .venv-init

# Install dependencies
make .pip-install

# Run Python tests
make .test-python

# Create Python package
make .package-python
```

2. **Example Python Project Structure**
```
my-python-project/
├── setup.py
├── requirements.txt
├── src/
│   └── main.py
└── tests/
    └── test_main.py
```

## Docker Development

### Using Pre-built Images

1. **C++ Development**
```bash
# Run C++ environment
docker run -it --rm \
  -v "$(pwd):/workspace" \
  your-registry.com/cpp:latest
```

2. **Python Development**
```bash
# Run Python environment
docker run -it --rm \
  -v "$(pwd):/workspace" \
  your-registry.com/python:latest
```

### Quick Docker Commands

```bash
# Build all images
docker-compose build

# Run specific service
docker-compose up cpp
docker-compose up python

# Clean up
docker-compose down
```

## CI/CD Pipeline

### Manual Pipeline Triggers

1. **Trigger full pipeline**
```bash
git push origin main
```

2. **Trigger specific jobs**
```bash
# Via GitLab UI
CI/CD > Pipelines > Run Pipeline
```

### Pipeline Variables

```bash
# Common overrides
variables:
  BUILD_TYPE: Debug
  PARALLEL_JOBS: "4"
```

## Common Tasks

### Adding Dependencies

1. **C++ Dependencies**
   - Add to docker/cpp/Dockerfile
   ```dockerfile
   RUN apt-get update && apt-get install -y \
       your-package-name
   ```

2. **Python Dependencies**
   - Add to requirements.txt
   ```text
   your-package==1.2.3
   ```

### Running Tests

```bash
# All tests
make test

# Specific language tests
make .test-cpp
make .test-python

# With coverage
make test COVERAGE=1
```

### Debugging

1. **Build Issues**
```bash
# Verbose output
make build VERBOSE=1

# Clean build
make clean
make build
```

2. **Pipeline Issues**
```bash
# Check job logs in GitLab UI
CI/CD > Pipelines > [pipeline] > [job]
```

## Best Practices

### Code Organization
- Keep language-specific code separate
- Use consistent directory structure
- Follow language conventions

### Build System
- Use language-specific targets
- Leverage parallel builds
- Maintain clean dependencies

### CI/CD
- Keep pipelines focused
- Use caching effectively
- Monitor build times

## Next Steps

1. Read the detailed [Build System Documentation](../build-system/overview.md)
2. Learn about [Docker Environments](../docker/base-image.md)
3. Explore [CI/CD Features](../ci-cd/pipeline-overview.md)
4. Review [Troubleshooting](../troubleshooting/common-issues.md)

## Quick Reference

### Environment Variables
```bash
# Build configuration
export BUILD_TYPE=Release
export PARALLEL_JOBS=4

# Paths
export BUILD_DIR="$(pwd)/build"
export DIST_DIR="$(pwd)/dist"
```

### Make Targets
| Target | Description |
|--------|-------------|
| `build` | Build all targets |
| `test` | Run all tests |
| `package` | Create packages |
| `deploy` | Deploy packages |
| `.build-cpp` | Build C++ only |
| `.build-python` | Build Python only |

### Docker Images
| Image | Use Case |
|-------|----------|
| `base:latest` | Base development tools |
| `cpp:latest` | C++ development |
| `python:latest` | Python development |
