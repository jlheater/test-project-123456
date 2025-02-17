# Python build configuration
PYTHON ?= python3
PIP ?= pip3
VENV_DIR ?= .venv
PYTHON_BUILD_DIR := $(BUILD_DIR)/python
PYTHON_DIST_DIR := $(DIST_DIR)/python

# Test configuration
PYTEST ?= pytest
PYTEST_ARGS ?= -v

# Default targets (empty implementations to be defined in project)
.build-python:
$(call log,"Building Python project")
$(call ensure_dir,$(PYTHON_BUILD_DIR))

.test-python:
$(call log,"Testing Python project")

.package-python:
$(call log,"Packaging Python project")
$(call ensure_dir,$(PYTHON_DIST_DIR))

.deploy-python:
$(call log,"Deploying Python project")

.clean-python:
$(call log,"Cleaning Python build artifacts")
rm -rf $(PYTHON_BUILD_DIR) $(PYTHON_DIST_DIR) *.egg-info __pycache__ .pytest_cache

# Helper target to set up virtual environment
.venv-init:
$(call log,"Initializing Python virtual environment")
test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR)
. $(VENV_DIR)/bin/activate && $(PIP) install --upgrade pip

# Helper target to install dependencies
.pip-install:
$(call log,"Installing Python dependencies")
test -d $(VENV_DIR) || $(MAKE) .venv-init
. $(VENV_DIR)/bin/activate && $(PIP) install -r requirements.txt

# Helper target to configure Docker build
.docker-python-build:
$(call log,"Building Python Docker image")
docker build -f docker/python/Dockerfile \
--build-arg BUILD_TYPE=$(BUILD_TYPE) \
-t $(DOCKER_REGISTRY)/$(PROJECT_NAME)/python:$(DOCKER_TAG) .
