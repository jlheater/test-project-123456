# Common environment variables with defaults
BUILD_DIR ?= build
DIST_DIR ?= dist
CI_ENVIRONMENT ?= development

# Docker configuration
DOCKER_REGISTRY ?= registry.gitlab.com
PROJECT_NAME ?= $(shell basename $(PWD))
DOCKER_TAG ?= latest

# Build configuration
BUILD_TYPE ?= Release
PARALLEL_JOBS ?= $(shell nproc 2>/dev/null || echo 4)

# Function to log build steps
define log
	@echo "[$$(date '+%Y-%m-%d %H:%M:%S')] $(1)"
endef

# Function to check required commands
check_command = $(shell command -v $(1) 2>/dev/null)

# Function to create directories if they don't exist
ensure_dir = @mkdir -p $(1)

# Determine OS for conditional compilation
OS := $(shell uname -s)
ifeq ($(OS),Darwin)
	OS_NAME := macos
else ifeq ($(OS),Linux)
	OS_NAME := linux
else
	OS_NAME := unknown
endif
