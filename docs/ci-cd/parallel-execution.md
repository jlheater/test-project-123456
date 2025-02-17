# Parallel Job Execution

## Overview

Parallel job execution in GitLab CI/CD allows simultaneous processing of independent tasks, significantly reducing pipeline execution time. This guide covers strategies for implementing and optimizing parallel execution with project-specific runners. If you're migrating from language-specific jobs (.build-cpp, .build-python), see the [Migration Guide](../build-system/migration-guide.md).

```mermaid
flowchart TD
    Trigger[Pipeline Trigger] --> Split[Job Split]
    Split --> Jobs["Parallel Jobs"]
    
    subgraph Config["Project Configuration"]
        Type["PROJECT_TYPE"]
    end
    
    subgraph Jobs["Parallel Execution"]
        Debug["Debug Build"]
        Release["Release Build"]
        Unit["Unit Tests"]
        Integration["Integration Tests"]
    end
    
    Type --> Jobs
    Jobs --> Merge[Results Collection]
    Merge --> Next[Next Stage]
```

## Configuration Methods

### Matrix Jobs

```yaml
build:
  variables:
    PROJECT_TYPE: cpp  # or 'python'
  parallel:
    matrix:
      - BUILD_TYPE: [Debug, Release]
  script:
    - make build BUILD_TYPE=$BUILD_TYPE
```

### Multiple Job Definitions
```yaml
build:debug:
  variables:
    PROJECT_TYPE: cpp
    BUILD_TYPE: Debug
  script:
    - make build

build:release:
  variables:
    PROJECT_TYPE: cpp
    BUILD_TYPE: Release
  script:
    - make build
```

## Resource Management

### Job Distribution
```yaml
default:
  interruptible: true
  tags:
    - $PROJECT_TYPE

variables:
  GIT_STRATEGY: fetch
```

### Runner Configuration
```yaml
.build_job:
  parallel: 4
  resource_group: build
  variables:
    PARALLEL_JOBS: 2
```

## Optimization Strategies

### Build Matrix Organization
```mermaid
flowchart LR
    subgraph Matrix["Build Matrix"]
        direction TB
        Debug["Debug Build"]
        Release["Release Build"]
    end
    
    subgraph Tests["Test Matrix"]
        direction TB
        Unit["Unit Tests"]
        Integration["Integration"]
        Coverage["Coverage"]
    end
    
    Matrix --> Tests
```

### Dependencies Management
```yaml
# Job dependencies
test:
  needs:
    - job: build
      artifacts: true
  parallel:
    matrix:
      - TEST_SUITE: [unit, integration]
```

## Common Patterns

### Project-Type Specific Parallel Jobs

#### C++ Configuration
```yaml
variables:
  PROJECT_TYPE: cpp

.build_matrix:
  parallel:
    matrix:
      - BUILD_TYPE: [Debug, Release]
      - ARCH: [x86_64, arm64]
    exclude:
      - BUILD_TYPE: Debug
        ARCH: arm64

build:
  extends: .build_matrix
  script:
    - make build
```

#### Python Configuration
```yaml
variables:
  PROJECT_TYPE: python

.test_matrix:
  parallel:
    matrix:
      - PYTHON_VERSION: [3.9, 3.11]
      - TEST_TYPE: [unit, integration]

test:
  extends: .test_matrix
  script:
    - make test
```

## Resource Optimization

### Cache Strategy
```yaml
.cached_job:
  cache:
    key:
      files:
        - Makefile
        - CMakeLists.txt  # For C++ projects
        - pyproject.toml  # For Python projects
    paths:
      - build/
      - dist/
    policy: pull-push
```

### Artifact Management
```yaml
.artifact_job:
  artifacts:
    expire_in: 1 week
    paths:
      - build/
      - dist/
    when: on_success
```

## Performance Tuning

### Job Parallelization
```yaml
# Optimize parallel execution
variables:
  PARALLEL_JOBS: 4
  CMAKE_BUILD_PARALLEL_LEVEL: 4  # For C++ projects
  PYTEST_ADDOPTS: "-n auto"      # For Python projects
```

### Resource Allocation
```yaml
.resource_config:
  variables:
    FF_USE_FASTZIP: "true"
  resource_group: ${CI_JOB_NAME}
```

## Pipeline Organization

### Stage Distribution
```mermaid
flowchart TD
    Build["Build Stage"] --> Test["Test Stage"]
    
    subgraph Build
        Debug["Debug Build"]
        Release["Release Build"]
    end
    
    subgraph Test
        Unit["Unit Tests"]
        Integration["Integration"]
    end
```

### Workflow Rules
```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      variables:
        PARALLEL_JOBS: 2
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      variables:
        PARALLEL_JOBS: 4
```

## Best Practices

### Job Design
- Use PROJECT_TYPE for runner selection
- Create independent execution paths
- Minimize shared resources
- Handle artifacts efficiently

### Resource Usage
- Set appropriate parallelization
- Optimize caching
- Allocate resource groups
- Distribute runners properly

### Pipeline Efficiency
- Split jobs strategically
- Manage dependencies
- Aggregate results
- Progress through stages clearly

## Monitoring

### Performance Metrics
```yaml
.monitored_job:
  variables:
    CI_DEBUG_TRACE: "true"
  after_script:
    - echo "Job duration: $CI_JOB_DURATION"
```

### Resource Tracking
```yaml
.resource_tracking:
  before_script:
    - df -h
    - free -m
  after_script:
    - df -h
    - free -m
```

## Troubleshooting

### Common Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| Runner selection | Wrong PROJECT_TYPE | Verify PROJECT_TYPE |
| Resource contention | Over-parallelization | Adjust parallel jobs |
| Cache conflicts | Shared cache keys | Use distinct keys |
| Runner overload | Too many jobs | Configure job limits |
| Migration issues | Incorrect setup | See [Migration Guide](../build-system/migration-guide.md) |

### Debug Configuration
```yaml
.debug_parallel:
  variables:
    CI_DEBUG_TRACE: "true"
    FF_DEBUG_JOB: "true"
  before_script:
    - set -x
```

## Examples

### Complex Matrix
```yaml
test:matrix:
  parallel:
    matrix:
      - BUILD_TYPE: [Debug, Release]
      - TEST_SUITE: [unit, integration]
      - COVERAGE: [true, false]
    exclude:
      - BUILD_TYPE: Release
        COVERAGE: true
```

### Resource Groups
```yaml
build:parallel:
  parallel: 4
  resource_group: ${CI_JOB_NAME}
  script:
    - make build -j${PARALLEL_JOBS}
```

## See Also

- [Pipeline Overview](pipeline-overview.md)
- [Job Templates](job-templates.md)
- [Migration Guide](../build-system/migration-guide.md) - For transitioning from language-specific jobs
- [Caching Strategy](caching-strategy.md)
