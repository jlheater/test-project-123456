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
    end

    subgraph Projects["Project Types"]
        subgraph CPP["C++ Projects"]
            MAKE["Make-based"]
            CMAKE["CMake-based"]
            
            subgraph CPP_Tools["Build Tools"]
                CCACHE["ccache"]
                NINJA["ninja"]
            end
        end
        
        subgraph PY["Python Projects"]
            PY39["Python 3.9 (setup.py)"]
            PY311["Python 3.11 (toml)"]
            
            subgraph PY_Tools["Build Tools"]
                VENV["virtualenv"]
                PIP["pip"]
                NOX["nox"]
            end
        end
    end

    B & T & P & D --> CPP
    B & T & P & D --> PY

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
        Templates[".gitlab/ci/*.yml"]
        Config["PROJECT_TYPE"]
        
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
           Cache["ccache"]
           Monitoring["prometheus-client"]
       end
       
       subgraph Optimizations["Build Optimizations"]
           Layer["Layer Caching"]
           Deps["Dependency Cache"]
           Artifacts["Build Artifacts"]
       end
       
       Common --> Tools
       Tools --> Optimizations
   ```

3. **Cache Optimization Patterns**
   ```mermaid
   flowchart TD
       subgraph Layers["Layer Strategy"]
           OS["OS Dependencies"]
           Tools["Build Tools"]
           Lang["Language Tools"]
           Deps["Project Dependencies"]
       end

       subgraph Cache["Cache Types"]
           Docker["Docker Layer Cache"]
           Runner["Runner Cache"]
           Deps["Dependency Cache"]
           Build["Build Cache"]
       end

       subgraph Invalidation["Cache Invalidation"]
           Time["Time-based"]
           Hash["Hash-based"]
           Manual["Manual Clear"]
       end

       Layers --> Cache
       Cache --> Invalidation
   ```

### Pipeline Design
1. **Template Structure**
   ```mermaid
   flowchart LR
       Base["base.gitlab-ci.yml"]
       CPP["cpp.gitlab-ci.yml"]
       PY["python.gitlab-ci.yml"]
       Main[".gitlab-ci.yml"]
       
       Base --> CPP & PY
       CPP & PY --> Main
   ```

2. **Job Organization**
   ```mermaid
   flowchart TD
       Pre["Pre Stage"]
       Build["Build Stage"]
       Test["Test Stage"]
       Package["Package Stage"]
       Deploy["Deploy Stage"]
       
       Pre --> Build
       Build --> Test
       Test --> Package
       Package --> Deploy
       
       subgraph Parallel["Parallel Execution"]
           CPP["C++ Jobs"]
           PY["Python Jobs"]
       end
       
       Build --> Parallel
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
- Base CI configuration defines workflow
- Language-specific configurations implement details
- Common job templates
- Standardized stage progression

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
        Cache["Build Cache"]
    end
    
    Implementation --> Docker
```

### CI/CD Flow
```mermaid
flowchart LR
    Trigger["Pipeline Trigger"] --> Pre["Docker Builds"]
    Pre --> Build["Language Builds"]
    Build --> Test["Parallel Tests"]
    Test --> Package["Packaging"]
    Package --> Deploy["Deployment"]
    
    subgraph Cache["Caching"]
        DC["Docker Layers"]
        BC["Build Artifacts"]
        TC["Test Results"]
    end
    
    Build --> Cache
    Test --> Cache
