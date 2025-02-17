# Migration Guide

## Overview

This guide helps you migrate from language-specific make targets (`.build-cpp`, `.build-python`) to the new generic make target approach with project-specific implementations.

## Key Changes

1. **Make Targets**
   - Old: Language-specific targets (`.build-cpp`, `.build-python`)
   - New: Generic targets (`build`, `test`, `package`, `deploy`)

2. **Project Type**
   - Old: Determined by make target used
   - New: Specified in .gitlab-ci.yml via PROJECT_TYPE

3. **Build Implementation**
   - Old: Shared language-specific makefiles
   - New: Project-specific Makefile implementation

## Migration Steps

### 1. Update .gitlab-ci.yml

#### Old Configuration
```yaml
include:
  - local: .gitlab/ci/base.gitlab-ci.yml
  - local: .gitlab/ci/cpp.gitlab-ci.yml  # or python.gitlab-ci.yml

build:
  script:
    - make .build-cpp  # or .build-python
```

#### New Configuration
```yaml
include:
  - local: .gitlab/ci/base.gitlab-ci.yml

variables:
  PROJECT_TYPE: cpp  # or 'python'

build:
  script:
    - make build
```

### 2. Update Makefile

#### C++ Project Migration

Old Makefile:
```makefile
include make/common.mk
include make/cpp.mk

.PHONY: all
all: .build-cpp .test-cpp
```

New Makefile:
```makefile
.PHONY: build test package deploy clean

# Variables
CXX ?= g++
CXXFLAGS += -Wall -Wextra
BUILD_DIR ?= build
DIST_DIR ?= dist

# Targets
build:
    $(CXX) $(CXXFLAGS) src/*.cpp -o $(BUILD_DIR)/program

test:
    ./$(BUILD_DIR)/program --test

package:
    tar -czf $(DIST_DIR)/program.tar.gz $(BUILD_DIR)/program

deploy:
    # Implementation specific

clean:
    rm -rf $(BUILD_DIR) $(DIST_DIR)
```

#### Python Project Migration

Old Makefile:
```makefile
include make/common.mk
include make/python.mk

.PHONY: all
all: .build-python .test-python
```

New Makefile (Python 3.9):
```makefile
.PHONY: build test package deploy clean

# Variables
VENV ?= .venv
PYTHON ?= python3.9
PYTEST_ARGS ?= -v

# Targets
build:
    $(PYTHON) -m venv $(VENV)
    . $(VENV)/bin/activate && pip install -e .

test:
    . $(VENV)/bin/activate && pytest $(PYTEST_ARGS) tests/

package:
    . $(VENV)/bin/activate && python setup.py sdist bdist_wheel

deploy:
    # Implementation specific

clean:
    rm -rf build/ dist/ *.egg-info/ $(VENV)/
```

New Makefile (Python 3.11+):
```makefile
.PHONY: build test package deploy clean

# Variables
VENV ?= .venv
PYTHON ?= python3.11
NOX_SESSION ?= tests

# Targets
build:
    $(PYTHON) -m venv $(VENV)
    . $(VENV)/bin/activate && pip install -e ".[dev]"

test:
    . $(VENV)/bin/activate && nox -s $(NOX_SESSION)

package:
    . $(VENV)/bin/activate && python -m build

deploy:
    # Implementation specific

clean:
    rm -rf build/ dist/ *.egg-info/ $(VENV)/ .nox/
```

### 3. Update Docker Configuration

#### Old Approach
```yaml
# .gitlab-ci.yml
cpp:build:
  image: $CI_REGISTRY_IMAGE/cpp:latest

python:build:
  image: $CI_REGISTRY_IMAGE/python:latest
```

#### New Approach
```yaml
# .gitlab-ci.yml
variables:
  PROJECT_TYPE: cpp  # or 'python'

build:
  image: $CI_REGISTRY_IMAGE/$PROJECT_TYPE:latest
```

### 4. Update Cache Configuration

#### Old Configuration
```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}-cpp  # or -python
  paths:
    - build/cpp/  # or build/python/
    - .ccache/    # or .venv/
```

#### New Configuration
```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}-${PROJECT_TYPE}
  paths:
    - build/
    - dist/
    # Project-specific paths
    - .ccache/     # For C++ projects
    - .venv/       # For Python projects
```

## Common Migration Issues

### 1. Build Problems
- Issue: Missing build implementation
- Solution: Copy relevant build logic from old language-specific makefiles

### 2. CI/CD Issues
- Issue: Wrong runner selection
- Solution: Verify PROJECT_TYPE is set correctly

### 3. Cache Issues
- Issue: Cache misses after migration
- Solution: Update cache keys and paths

## Best Practices

### 1. Project Organization
- Keep build logic in project Makefile
- Document build requirements
- Maintain clear target behavior

### 2. CI/CD Configuration
- Set PROJECT_TYPE explicitly
- Use provided runners
- Follow caching guidelines

### 3. Testing
- Verify all targets work locally
- Test CI/CD pipeline thoroughly
- Monitor build performance

## Migration Checklist

1. **Preparation**
   - [ ] Backup current Makefile
   - [ ] Document current build process
   - [ ] List all custom targets

2. **Implementation**
   - [ ] Create new Makefile
   - [ ] Add generic targets
   - [ ] Update .gitlab-ci.yml
   - [ ] Set PROJECT_TYPE

3. **Validation**
   - [ ] Test locally
   - [ ] Test in CI/CD
   - [ ] Verify caching
   - [ ] Check performance

4. **Cleanup**
   - [ ] Remove old makefiles
   - [ ] Update documentation
   - [ ] Remove unused configurations

## See Also

- [Build System Overview](overview.md)
- [Makefile Targets](makefile-targets.md)
- [C++ Builds](cpp-builds.md)
- [Python Builds](python-builds.md)
