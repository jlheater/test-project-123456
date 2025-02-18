# Active Context

## Current Focus
- Restructuring CI/CD pipeline organization from language-based to stage-based
- Creating template repositories for Python and C++ projects
- Ensuring diagram consistency across all documentation
- Adding Python 3.6 compatibility support

## Recently Completed
- ✅ Created comprehensive Makefile documentation with makefile-guide.md
- ✅ Documented standard targets (build, test, package, lint, format)
- ✅ Established Makefile best practices and patterns
- ✅ Provided reference implementations for C++ and Python

## Recent Changes
- Completed comprehensive Makefile documentation in makefile-guide.md
- Decided to reorganize CI/CD pipeline structure by stages instead of languages
- Identified need for template repositories to replace make/ directory
- Updated build system architecture to use root-level Makefiles with common targets
- Enhanced Makefile examples with comprehensive documentation
- Added support for Python 3.6 alongside 3.9 and 3.11
- Removed caching strategy from scope
- Added lint and format make targets

## Active Decisions

### Build System Implementation
- Single Makefile per project with generic targets (build, test, package, lint, format)
- Project type specification in .gitlab-ci.yml
- Standardized target names across all projects
- Support for both legacy and new build patterns

### Pipeline Implementation
- Stage-based CI/CD organization (.gitlab/ci/stages/)
- Job-specific configurations (.gitlab/ci/jobs/)
- Shared templates for common patterns
- Stage-oriented pipeline structure for better clarity

### Infrastructure Design
- Base image for common tools and utilities
- Language-specific images extending base
- Standardized environment variables

## Next Steps
1. **CI/CD Reorganization**
   - Create stage-based YAML structure
   - Implement job-specific configurations
   - Update pipeline templates
   - Document new organization

2. **Template Repositories**
   - Create template-cpp-project repository
   - Create template-python-project repository with multi-Python support (3.6, 3.9, 3.11)
   - Document template usage
   - Provide migration guides

2. **Build System Transition**
   - Document generic make target implementation
   - Create migration guides for existing projects
   - Update CI/CD templates for PROJECT_TYPE specification

3. **Workflow Documentation**
   - Create clear developer guides for day-to-day operations
   - Document build engineer procedures for infrastructure changes
   - Update Docker development workflows

## Current Considerations
1. **Documentation Structure**
   - Separating developer and build engineer concerns
   - Maintaining clear upgrade paths for Python/C++ projects
   - Ensuring comprehensive troubleshooting coverage

2. **Build System Clarity**
   - Making generic targets intuitive
   - Supporting both Make and CMake for C++
   - Handling Python versions (3.6, 3.9, 3.11) configurations
   - Implementing lint and format targets consistently

3. **Implementation Guidelines**
   - Clear distinction between current and new project setups
   - Docker development workflow documentation
   - GitLab runner selection and configuration
   - Python version compatibility requirements

## Implementation Insights
- Generic make targets simplify maintenance
- Explicit project type improves pipeline clarity
- Separated documentation enhances usability
- Clear upgrade paths aid project evolution
- Format and lint targets ensure code quality

## Open Questions
- Impact of stage-based CI/CD organization on existing projects
- Best approach for template repository maintenance
- Process for keeping Makefile documentation current
- Timeline for deprecating make/ directory
- Python package version constraints for 3.6 compatibility
