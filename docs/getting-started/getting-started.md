# Getting Started Guide

## Quick Start
### Project Setup Essentials
```bash
# Clone your project
git clone https://gitlab.com/your-org/your-project.git
cd your-project

# Configure project type in .gitlab-ci.yml
echo 'variables:
  PROJECT_TYPE: cpp  # or "python" for Python projects' > .gitlab-ci.yml

# Core commands
make build    # Build project
make test     # Run tests
make package  # Create package
make deploy   # Deploy (if configured)
```

### Templates & Examples

**C++ Project Structure:**
```
my-cpp-project/
├── Makefile           # Generic targets (build, test, etc.)
├── CMakeLists.txt    # If using CMake
├── src/
│   └── main.cpp
└── tests/
    └── test_main.cpp
```

**Python Project Structure:**
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

**Basic CI/CD Configuration:**
```yaml
include:
  - project: 'your-org/pipeline-templates'
    file: '/templates/base.yml'

variables:
  PROJECT_TYPE: cpp  # or 'python'
  BUILD_TYPE: Release
  PARALLEL_JOBS: "4"
```

## Detailed Guide

### Developer Guide

#### 1. Prerequisites & Setup

**Required Tools:**
- Git >= 2.40
- Make >= 4.4
- Docker >= 24.x (for local testing)
- Language-specific tools:
  - C++: GCC >= 12.0 or Clang >= 16.0, CMake >= 3.27
  - Python: Python >= 3.11, virtualenv >= 20.24

**Environment Configuration:**
```bash
# Common environment variables
export BUILD_TYPE=Release
export PARALLEL_JOBS=4
export CCACHE_DIR=/path/to/cache
export PYTHONPATH=/path/to/modules
```

#### 2. Development Workflow

**Building & Testing:**
```bash
# Build with specific configuration
make build BUILD_TYPE=Debug

# Run specific tests
make test TEST_FILTER="TestSuite.TestCase"  # C++ projects
make test PYTEST_ARGS="-k test_function"    # Python projects

# Clean build artifacts
make clean
```

**CI/CD Usage:**
- Available runner tags:
  - `base`: Common tools and utilities
  - `cpp`: C++ development environment
  - `python`: Python development environment

**Common Issues:**
1. Build failures:
   - Check PROJECT_TYPE setting
   - Verify required tools
   - Clean and rebuild

2. Test failures:
   - Review test logs
   - Check environment setup
   - Verify dependencies

### Build Engineer Guide

#### 1. Environment Setup

**Docker Configuration:**
```bash
# Set up environment
export DOCKER_REGISTRY="your-registry.com"

# Build and test images
cd docker/base
docker build -t $DOCKER_REGISTRY/base:latest .
docker push $DOCKER_REGISTRY/base:latest

cd ../cpp
docker build -t $DOCKER_REGISTRY/cpp:latest .
docker push $DOCKER_REGISTRY/cpp:latest

cd ../python
docker build -t $DOCKER_REGISTRY/python:latest .
docker push $DOCKER_REGISTRY/python:latest
```

**Runner Management:**
```bash
# Register GitLab runner
gitlab-runner register \
  --url "https://gitlab.com/" \
  --registration-token "YOUR_TOKEN" \
  --executor "docker" \
  --docker-image $DOCKER_REGISTRY/base:latest \
  --tag-list "base"
```

#### 2. Advanced Configuration

**Cache Optimization:**
```dockerfile
# Build with cache mounting
docker build \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from $DOCKER_REGISTRY/cpp:latest \
  -t $DOCKER_REGISTRY/cpp:latest .
```

**Performance Monitoring:**
- Job execution times
- Cache hit rates
- Resource utilization
- Runner performance

### Best Practices

#### Development Standards
- Use generic make targets
- Follow language conventions
- Keep builds reproducible
- Document configuration changes

#### Docker Optimization
- Minimal base images
- Efficient layer caching
- Multi-stage builds
- Regular security updates

#### CI/CD Patterns
- Template inheritance
- Parallel execution
- Artifact management
- Cache strategies

### Reference

#### Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| BUILD_TYPE | Build configuration | Release |
| PARALLEL_JOBS | Number of parallel jobs | 4 |
| CCACHE_DIR | Compiler cache directory | ~/.ccache |
| PYTHONPATH | Python module path | ./src |

#### Make Targets
| Target | Description |
|--------|-------------|
| build | Build project |
| test | Run tests |
| package | Create package |
| deploy | Deploy package |

#### Runner Configuration
| Tag | Purpose |
|-----|----------|
| base | Common tools |
| cpp | C++ environment |
| python | Python environment |

## Next Steps
1. Review [Build System Documentation](../build-system/overview.md)
2. Explore [CI/CD Features](../ci-cd/pipeline-overview.md)
3. Check [Troubleshooting Guide](../troubleshooting/common-issues.md)
