# System Requirements

## Table of Contents
- [Core Dependencies](#core-dependencies)
  - [Required Software](#required-software)
  - [GitLab Integration](#gitlab-integration)
- [Language-Specific Requirements](#language-specific-requirements)
  - [C++ Development](#c-development)
  - [Python Development](#python-development)
- [Environment Variables](#environment-variables)
  - [Required Variables](#required-variables)
  - [Optional Variables](#optional-variables)
- [System Resources](#system-resources)
  - [Minimum Requirements](#minimum-requirements)
  - [Recommended](#recommended)
- [Operating System Support](#operating-system-support)
  - [Linux](#linux)
  - [macOS](#macos)
  - [Windows](#windows)
- [Additional Tools](#additional-tools-recommended)
  - [Development Tools](#development-tools)
  - [Monitoring Tools](#monitoring-tools)
- [Network Requirements](#network-requirements)
  - [Connectivity](#connectivity)
  - [Firewall Rules](#firewall-rules)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Core Dependencies

### Required Software
| Software | Minimum Version | Description |
|----------|----------------|-------------|
| Git | 2.40+ | Version control system |
| Docker | 24.x | Container runtime |
| Make | 4.4+ | Build orchestration |
| Python | 3.11+ | Python development |
| CMake | 3.27+ | C++ build system |
| Ninja | 1.11+ | Build system for C++ |

### GitLab Integration
- GitLab account with repository access
- GitLab Runner access
- Container Registry access

## Language-Specific Requirements

### C++ Development
- GCC >= 12.0 or Clang >= 16.0
- CMake 3.27 or higher
- Ninja build system >= 1.11
- ccache >= 4.8
- Boost libraries >= 1.83 (optional)
- GoogleTest >= 1.14 (for testing)

### Python Development
- Python 3.11 or higher
- virtualenv/venv >= 20.24
- pip >= 23.2 with wheel support
- Development packages:
  - pytest >= 7.4 for testing
  - black >= 23.7 for formatting
  - pylint >= 3.0 for linting
  - coverage >= 7.3 for code coverage

## Environment Variables

### Required Variables
```bash
# GitLab Configuration
export CI_REGISTRY="your-gitlab-registry.com"
export CI_REGISTRY_IMAGE="$CI_REGISTRY/your-project"
export CI_PROJECT_PATH="your/project/path"

# Build Configuration
export BUILD_TYPE="Release"  # or "Debug"
export BUILD_DIR="build"
export DIST_DIR="dist"
```

### Optional Variables
```bash
# Performance Tuning
export PARALLEL_JOBS="4"  # or number of CPU cores
export CCACHE_DIR=".ccache"

# Python Configuration
export VIRTUAL_ENV=".venv"
export PYTHONPATH="$PWD"
```

## System Resources

### Minimum Requirements
- CPU: 2 cores
- RAM: 4 GB
- Storage: 10 GB available

### Recommended
- CPU: 4+ cores
- RAM: 8+ GB
- Storage: 20+ GB SSD
- Network: High-speed internet connection

## Operating System Support

### Linux
- Ubuntu 20.04 LTS or newer
- Debian 11 (Bullseye) or newer
- CentOS 8 Stream or newer
- Other Linux distributions with equivalent packages

### macOS
- macOS 11 (Big Sur) or newer
- Homebrew for package management
- XCode Command Line Tools

### Windows
- Windows 10/11 with WSL2
- Docker Desktop for Windows
- Git Bash or similar POSIX-compatible shell

## Additional Tools (Recommended)

### Development Tools
- Visual Studio Code or similar IDE
- GitLab CLI (glab)
- Docker Compose
- ShellCheck for script validation

### Monitoring Tools
- Docker stats
- Resource monitoring
- Network tools
- prometheus-client >= 0.17

## Network Requirements

### Connectivity
- Access to GitLab instance
- Access to Container Registry
- Access to package repositories

### Firewall Rules
- Allow Docker registry access (usually port 5000)
- Allow GitLab SSH (port 22) and HTTPS (port 443)
- Allow package manager access

## Verification

Run the following commands to verify your setup:

```bash
# Core tools
git --version
docker --version
make --version
python3 --version
cmake --version

# C++ toolchain
g++ --version  # or clang++ --version
ninja --version

# Python tools
pip3 --version
virtualenv --version

# Docker functionality
docker run hello-world
```

## Troubleshooting

If you encounter issues with the requirements:

1. Check the [troubleshooting guide](../troubleshooting/common-issues.md)
2. Verify all environment variables are set correctly
3. Ensure all required tools are in your PATH
4. Confirm Docker daemon is running
5. Verify GitLab access credentials

## Next Steps

Once all requirements are met:
1. Proceed to [Getting Started Guide](getting-started.md)
2. Set up your first project
