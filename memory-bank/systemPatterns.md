# System Patterns

## Core Architecture

### Pipeline Architecture
```mermaid
flowchart TD
    subgraph Make["Generic Makefile Targets"]
        B[build]
        T[test]
        P[package]
        D[deploy]
        L[lint]
        F[format]
    end

    subgraph Projects["Project Types"]
        subgraph CPP["C++ Projects"]
            MAKE["Make-based"]
            CMAKE["CMake-based"]
        end
        
        subgraph PY["Python Projects"]
            PY36["Python 3.6 (setup.py)"]
            PY39["Python 3.9 (setup.py)"]
            PY311["Python 3.11 (toml)"]
            
            subgraph PY_Tools["Build Tools"]
                VENV["virtualenv"]
                PIP["pip"]
                NOX["nox"]
            end
        end
    end

    B & T & P & D & L & F --> CPP
    B & T & P & D & L & F --> PY

    subgraph Config["Project Configuration"]
        TYPE["PROJECT_TYPE in .gitlab-ci.yml"]
    end

    TYPE --> CPP
    TYPE --> PY
```

### Component Architecture
```mermaid
flowchart TD
    subgraph CI["GitLab CI/CD"]
        Base[".gitlab-ci.yml"]
        Templates[".gitlab/ci/"]
        Config["PROJECT_TYPE"]
        
        subgraph Templates
            Stages["stages/*.yml"]
            Jobs["jobs/*.yml"]
            Common["templates/*.yml"]
        end
        
        Base --> Templates
        Config --> Templates
    end

    subgraph Docker["Docker Images"]
        BaseImg["Base Image"]
        CPPImg["C++ Image"]
        PyImg["Python Image"]
        
        BaseImg --> CPPImg
        BaseImg --> PyImg
    end

    subgraph Make["Project Makefiles"]
        Generic["Generic Targets"]
        Impl["Project-Specific Implementation"]
        
        Generic --> Impl
    end

    Templates --> Docker
    Docker --> Make
```

## Key Technical Decisions

### Build System Implementation
1. **Project Makefiles**
   ```mermaid
   flowchart TD
       subgraph Project["Project Repository"]
           M["Makefile"]
           I["Implementation"]
       end
       
       subgraph Targets["Generic Targets"]
           B["build"]
           T["test"]
           P["package"]
           D["deploy"]
           L["lint"]
           F["format"]
           H["help"]
       end
       
       M --> I
       I --> Targets
       
       subgraph Type["Project Type"]
           V["PROJECT_TYPE in .gitlab-ci.yml"]
           R["Runner Selection"]
       end
       
       V --> R
       R --> I
   ```

2. **Docker Structure**
   ```mermaid
   flowchart TD
       Base["debian:bullseye-slim"]
       Common["Base Image"]
       CPP["C++ Image"]
       PY["Python Image"]
       
       Base --> Common
       Common --> CPP & PY
       
       subgraph Tools["Common Tools"]
           Git["git"]
           Make["make"]
           Curl["curl"]
       end
       
       Common --> Tools
   ```

### Pipeline Design
1. **Stage-Based Structure**
   ```mermaid
   flowchart TD
       Base[".gitlab/ci/templates/default.yml"]
       Stages[".gitlab/ci/stages/*.yml"]
       Jobs[".gitlab/ci/jobs/*.yml"]
       Main[".gitlab-ci.yml"]
       
       Base --> Stages & Jobs
       Stages & Jobs --> Main
       
       subgraph Stages["Stage Definitions"]
           Build["build.yml"]
           Test["test.yml"]
           Lint["lint.yml"]
           Format["format.yml"]
           Package["package.yml"]
           Deploy["deploy.yml"]
       end
       
       subgraph Jobs["Job Definitions"]
           Compile["compile.yml"]
           UnitTest["unit-tests.yml"]
           IntegTest["integration-tests.yml"]
           CodeQuality["code-quality.yml"]
           Pack["packaging.yml"]
       end
   ```

2. **Template Repository Structure**
   ```mermaid
   flowchart TD
       subgraph Templates["Template Repositories"]
           CPP["template-cpp-project"]
           PY["template-python-project"]
           
           subgraph Common["Common Structure"]
               Make["Makefile"]
               Doc["docs/"]
               Read["README.md"]
           end
           
           CPP --> Common
           PY --> Common
       end
       
       subgraph Targets["Standard Targets"]
           Build["build"]
           Test["test"]
           Package["package"]
           Deploy["deploy"]
           Lint["lint"]
           Format["format"]
           Help["help"]
       end
       
       Make --> Targets
   ```

## Design Patterns

### Factory Pattern (Build System)
- Project Makefile as concrete implementation
- Generic target interface
- Project-specific implementation
- Runner selection via PROJECT_TYPE

### Builder Pattern (Docker)
- Base image as foundation
- Staged construction for each language
- Common utilities in base
- Language-specific tools added progressively

### Template Method Pattern (CI/CD)
- Stage-based pipeline organization
- Common job templates
- Standardized stage progression
- Job-specific implementations

### Strategy Pattern (Build Process)
- Generic target interface
- Project-specific build strategies
- Build type determined by PROJECT_TYPE
- Flexible implementation options

## Component Relationships

### Build System Integration
```mermaid
flowchart LR
    Project[".gitlab-ci.yml"] --> Type["PROJECT_TYPE"]
    Type --> Runner["Runner Selection"]
    
    subgraph Implementation
        Make["Project Makefile"]
        Build["Build Strategy"]
    end
    
    Runner --> Implementation
    
    subgraph Docker
        Images["Container Images"]
    end
    
    Implementation --> Docker
```

### CI/CD Flow
```mermaid
flowchart LR
    Trigger["Pipeline Trigger"] --> Stages["Stage Execution"]
    
    subgraph Stages["Pipeline Stages"]
        Build["Build Stage"]
        Test["Test Stage"]
        Lint["Lint Stage"]
        Format["Format Stage"]
        Package["Package Stage"]
        Deploy["Deploy Stage"]
        
        Build --> Test
        Test --> Lint
        Lint --> Format
        Format --> Package
        Package --> Deploy
    end
    
    subgraph Jobs["Stage Jobs"]
        Compile["Compilation"]
        UnitTest["Unit Tests"]
        IntegTest["Integration Tests"]
        CodeQuality["Code Quality"]
        Pack["Packaging"]
    end
    
    Build --> Compile
    Test --> UnitTest & IntegTest
    Lint & Format --> CodeQuality
    Package --> Pack
