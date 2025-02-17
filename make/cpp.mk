# C++ build configuration
CXX ?= g++
CMAKE ?= $(call check_command,cmake)
CPP_BUILD_DIR := $(BUILD_DIR)/cpp
CPP_DIST_DIR := $(DIST_DIR)/cpp

# CMake configuration
CMAKE_BUILD_TYPE ?= $(BUILD_TYPE)
CMAKE_GENERATOR ?= "Unix Makefiles"

# Default targets (empty implementations to be defined in project)
.build-cpp:
	$(call log,"Building C++ project")
	$(call ensure_dir,$(CPP_BUILD_DIR))

.test-cpp:
	$(call log,"Testing C++ project")

.package-cpp:
	$(call log,"Packaging C++ project")
	$(call ensure_dir,$(CPP_DIST_DIR))

.deploy-cpp:
	$(call log,"Deploying C++ project")

.clean-cpp:
	$(call log,"Cleaning C++ build artifacts")
	rm -rf $(CPP_BUILD_DIR) $(CPP_DIST_DIR)

# Helper target to initialize CMake project
.cmake-init:
	$(call log,"Initializing CMake project")
	$(CMAKE) -B $(CPP_BUILD_DIR) \
		-G $(CMAKE_GENERATOR) \
		-DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE)

# Helper target to configure Docker build
.docker-cpp-build:
	$(call log,"Building C++ Docker image")
	docker build -f docker/cpp/Dockerfile \
		--build-arg BUILD_TYPE=$(BUILD_TYPE) \
		-t $(DOCKER_REGISTRY)/$(PROJECT_NAME)/cpp:$(DOCKER_TAG) .
