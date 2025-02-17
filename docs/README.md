# Build System & CI/CD Pipeline Documentation

## Overview

This documentation covers the build system and CI/CD pipeline implementation for multi-language projects supporting C++ and Python, with extensible support for C, Perl, and Fortran. The system provides:

- Language-agnostic build interface through Make
- Containerized build environments using Docker
- Modular GitLab CI/CD pipeline configuration
- Parallel job execution and optimization

## Documentation Structure

### 📚 [Getting Started](getting-started/)
- [Installation Requirements](getting-started/requirements.md)
- [Installation Guide](getting-started/installation.md)
- [Quick Start Guide](getting-started/quickstart.md)

### 🔧 [Build System](build-system/)
- [System Overview](build-system/overview.md)
- [Makefile Targets](build-system/makefile-targets.md)
- [C++ Build Configuration](build-system/cpp-builds.md)
- [Python Build Configuration](build-system/python-builds.md)

### 🐳 [Docker Environments](docker/)
- [Base Image Configuration](docker/base-image.md)
- [C++ Development Environment](docker/cpp-environment.md)
- [Python Development Environment](docker/python-environment.md)

### 🔄 [CI/CD Pipeline](ci-cd/)
- [Pipeline Overview](ci-cd/pipeline-overview.md)
- [Job Templates](ci-cd/job-templates.md)
- [Parallel Execution](ci-cd/parallel-execution.md)
- [Caching Strategy](ci-cd/caching-strategy.md)

### ❓ [Troubleshooting](troubleshooting/)
- [Common Issues](troubleshooting/common-issues.md)
- [Build Problems](troubleshooting/build-problems.md)
- [Pipeline Debugging](troubleshooting/pipeline-debugging.md)

## Quick Reference

### Key Make Targets
```bash
make build       # Build all language targets
make test        # Run all tests
make package     # Create distribution packages
make deploy      # Deploy packages
```

### Directory Structure
```
├── Makefile           # Main build orchestrator
├── make/             # Make components
│   ├── common.mk     # Shared utilities
│   ├── cpp.mk        # C++ specific rules
│   └── python.mk     # Python specific rules
├── docker/           # Docker environments
│   ├── base/         # Base image
│   ├── cpp/          # C++ environment
│   └── python/       # Python environment
└── .gitlab/          # CI/CD configuration
    └── ci/           # Pipeline templates
```

### Common Operations

#### Build Specific Language
```bash
make .build-cpp     # Build C++ projects
make .build-python  # Build Python projects
```

#### Test Specific Language
```bash
make .test-cpp      # Test C++ projects
make .test-python   # Test Python projects
```

## Contributing

See our [contribution guidelines](getting-started/installation.md#contributing) for information on how to add support for new languages or extend existing functionality.

## Support

For issues and questions:
1. Check the [Troubleshooting](troubleshooting/) guides
2. Search existing GitLab issues
3. Create a new issue with details from [Pipeline Debugging](troubleshooting/pipeline-debugging.md)
