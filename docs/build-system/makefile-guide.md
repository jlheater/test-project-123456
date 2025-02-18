# Makefile Guide

## Overview

This guide documents the standardized Makefile-based build system used across C++ and Python projects. Our build system uses language-agnostic Makefile targets to provide a consistent interface regardless of the underlying project type.

## Core Principles

### Generic Target Interface
Every project Makefile implements these standard targets:
- `build`: Compile/build the project
- `test`: Run all tests
- `package`: Create distributable artifacts
- `lint`: Run static code analysis
- `format`: Apply code formatting
- `help`: Display available targets

### Project Type Specification
Projects specify their type in `.gitlab-ci.yml`:
```yaml
variables:
  PROJECT_TYPE: cpp  # or python
```

This determines the appropriate runner selection and build implementation.

## Implementation Guide

### Common Structure
```makefile
.PHONY: build test package lint format help

# Default target
.DEFAULT_GOAL := help

# Common variables
BUILD_DIR ?= build
DIST_DIR ?= dist

# Helper function for help target
help:
	@echo "Available targets:"
	@echo "  build    - Build the project"
	@echo "  test     - Run all tests"
	@echo "  package  - Create distributable artifacts"
	@echo "  lint     - Run static code analysis"
	@echo "  format   - Apply code formatting"
	@echo "  help     - Display this help message"
```

### C++ Implementation Pattern
```makefile
# C++ specific variables
CMAKE ?= cmake
BUILD_TYPE ?= Release
PARALLEL_JOBS ?= $(shell nproc)

build:
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && $(CMAKE) .. \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
	@$(CMAKE) --build $(BUILD_DIR) -j $(PARALLEL_JOBS)

test:
	@cd $(BUILD_DIR) && ctest --output-on-failure

package:
	@cd $(BUILD_DIR) && cpack

lint:
	@clang-tidy $(shell find src -name '*.cpp' -o -name '*.hpp')

format:
	@clang-format -i $(shell find src -name '*.cpp' -o -name '*.hpp')
```

### Python Implementation Pattern
```makefile
# Python specific variables
PYTHON ?= python
VENV ?= .venv
PIP ?= $(VENV)/bin/pip

build:
	@$(PYTHON) -m venv $(VENV)
	@$(PIP) install -e .

test:
	@$(VENV)/bin/pytest

package:
	@$(PYTHON) -m build

lint:
	@$(VENV)/bin/pylint src tests

format:
	@$(VENV)/bin/black src tests
```

## Best Practices

### 1. Variable Declaration
- Use `?=` for overridable variables
- Use `:=` for immediate expansion
- Document environment variables in README.md
```makefile
# Overridable variables
PYTHON ?= python
BUILD_TYPE ?= Release

# Immediate expansion
SOURCES := $(shell find src -name '*.cpp')
```

### 2. Target Dependencies
- List all prerequisites
- Use order-only prerequisites where appropriate
- Document target relationships
```makefile
# Order-only prerequisite (directory creation)
$(BUILD_DIR)/%.o: src/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Directory creation
$(BUILD_DIR):
	@mkdir -p $@
```

### 3. Error Handling
- Use `@` for quiet execution
- Check command status
- Provide informative messages
```makefile
build:
	@echo "Building project..."
	@$(MAKE) -C $(BUILD_DIR) || (echo "Build failed"; exit 1)
```

### 4. Documentation
- Document all variables
- Explain target dependencies
- Include usage examples
```makefile
# BUILD_TYPE: Release or Debug (default: Release)
# PARALLEL_JOBS: Number of parallel jobs (default: nproc)
BUILD_TYPE ?= Release
PARALLEL_JOBS ?= $(shell nproc)
```

## Common Patterns

### 1. Directory Management
```makefile
# Create directories as needed
$(BUILD_DIR) $(DIST_DIR):
	@mkdir -p $@

# Clean build artifacts
clean:
	@rm -rf $(BUILD_DIR) $(DIST_DIR)
```

### 2. Conditional Logic
```makefile
# OS-specific commands
ifeq ($(OS),Windows_NT)
    RM := del /Q
else
    RM := rm -f
endif
```

### 3. Path Handling
```makefile
# Use paths relative to Makefile location
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_ROOT := $(MAKEFILE_DIR)
```

## Integration with CI/CD

The build system integrates with GitLab CI/CD through stage-based organization:

```yaml
# .gitlab-ci.yml
variables:
  PROJECT_TYPE: cpp  # or python

include:
  - template: 'Workflows/MergeRequest.gitlab-ci.yml'
  - local: '.gitlab/ci/stages/*.yml'
```

Stage jobs execute the corresponding Makefile targets:

```yaml
# .gitlab/ci/stages/build.yml
build:
  stage: build
  script:
    - make build
```

## Migration Guide

When migrating existing projects to this build system:

1. Add standard targets to your Makefile
2. Specify PROJECT_TYPE in .gitlab-ci.yml
3. Update CI/CD configuration to use stage-based structure
4. Implement language-specific target logic
5. Update documentation

## See Also
- [Makefile Targets Documentation](makefile-targets.md)
- [Pipeline Overview](../ci-cd/pipeline-overview.md)
- [Docker Environments](../docker/base-image.md)
