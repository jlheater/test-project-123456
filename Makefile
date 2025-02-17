# Standard GNU Make settings
SHELL := /bin/sh
.POSIX:
.SUFFIXES:
.PHONY: all build test package deploy clean

# Include language-specific makefiles
include make/common.mk
include make/cpp.mk
include make/python.mk

# Default target
all: build test

# Primary targets that delegate to language-specific implementations
build: .build-cpp .build-python

test: .test-cpp .test-python

package: .package-cpp .package-python

deploy: .deploy-cpp .deploy-python

# Clean all build artifacts
clean: .clean-cpp .clean-python
	@echo "Cleaning all build artifacts"
