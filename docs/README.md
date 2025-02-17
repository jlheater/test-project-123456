# Build System & CI/CD Pipeline Documentation

## Overview

This documentation covers the build system and CI/CD pipeline implementation for multi-language projects supporting C++ and Python, with extensible support for C, Perl, and Fortran. The system provides:

- Generic build targets with project-specific implementations
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

### Standard Make Targets
```bash
make build       # Build project
make test        # Run project tests
make package     # Create distribution package
make deploy      # Deploy package
```

### Directory Structure
```
├── Makefile           # Project-specific build implementation
├── docker/           # Docker environments
│   ├── base/         # Base image
│   ├── cpp/          # C++ environment
│   └── python/       # Python environment
└── .gitlab/          # CI/CD configuration
    └── ci/           # Pipeline templates
```

### Project Setup

#### C++ Projects
```yaml
# .gitlab-ci.yml
variables:
  PROJECT_TYPE: cpp  # Use C++ runner
```

#### Python Projects
```yaml
# .gitlab-ci.yml
variables:
  PROJECT_TYPE: python  # Use Python runner
```

### Available Runners
- `base`: Common tools and utilities
- `cpp`: C++ development environment (Make/CMake)
- `python`: Python development environment (3.9/3.11+)

## Developer vs Build Engineer Guides

### Developer Documentation
For day-to-day development operations such as:
- Making repository changes
- Building and testing locally
- Updating project CI/CD configuration

See the [Installation Guide](getting-started/installation.md#developer-guide) and [Quick Start Guide](getting-started/quickstart.md#developer-quickstart).

### Build Engineer Documentation
For infrastructure and tooling updates such as:
- Pipeline template modifications
- Docker environment updates
- GitLab runner configuration

See the [Installation Guide](getting-started/installation.md#build-engineer-guide) and [Docker Environment](docker/base-image.md#build-engineer-setup) documentation.

## Contributing

See our [contribution guidelines](getting-started/installation.md#contributing) for information on how to add support for new languages or extend existing functionality.

## Support

For issues and questions:
1. Check the [Troubleshooting](troubleshooting/) guides
2. Search existing GitLab issues
3. Create a new issue with details from [Pipeline Debugging](troubleshooting/pipeline-debugging.md)
