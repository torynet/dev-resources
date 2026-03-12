# Development and Build Environment Setup

📚 [Docs Home](index.md) → Development and Build Environment Setup

*[Complete navigation available on documentation home page](index.md)*

## Overview

This document defines the complete development, build, and deployment strategy for Storacle, a Second-Generation Managed Package (2GP) for Salesforce.
Our approach emphasizes trunk-based development, comprehensive multi-edition testing, and automated release management.

## Core Architecture Decisions

### 1. Package Development Model: Second-Generation Managed Package (2GP)

**Decision**: 100% Second-Generation Managed Package with namespace `strcl`

**Rationale**:

- Clean distribution and installation for customer orgs
- Namespace protection prevents metadata conflicts
- Automatic dependency management
- Clear versioning for customer support
- AppExchange distribution capability
- Managed upgrade paths

**Implementation**:

- `sfdx-project.json` configured for 2GP development
- All custom objects, fields, and Apex classes use `strcl__` namespace prefix
- Package directories organized for logical grouping
- Dev Hub org registered with `strcl` namespace

### 2. Environment Management: Full Scratch Org Strategy

**Decision**: 100% ephemeral scratch org approach - no persistent sandboxes

**Development Environments**:

- **Work Branch Scratch Orgs**: 7-day duration, rebuilt on expiry
- **CI Testing Scratch Orgs**: Created per pipeline run, disposed immediately
- **Multi-Edition Testing**: Parallel scratch orgs for all Salesforce editions

**Scratch Org Limits (Developer Edition Dev Hub)**:

- 200 scratch orgs per day (24-hour rolling window)
- 40 active scratch orgs at any time
- 40 namespace-enabled scratch orgs at any time

**Edition Testing Strategy**:

- **Developer Edition**: Basic functionality and free-tier testing
- **Professional Edition**: Mid-tier feature validation
- **Enterprise Edition**: Full feature set testing
- **Unlimited Edition**: Performance and scale validation

## Development Workflow

### Branching Strategy: Trunk-Based Development

**Branch Structure**:

- **main**: Single source of truth, always deployable
- **work/{issue-id}**: Short-lived work branches for individual GitHub issues
- **No long-lived feature branches** - all work merges to main quickly

**Commit Strategy**:

- **Squash commits to main** for clean history
- **Conventional commits** for breaking change hints:
  - `feat!: remove deprecated field` (breaking change)
  - `feat: add new measurement type` (non-breaking)
  - `BREAKING CHANGE:` footer for detailed breaking change descriptions

### Local Development Process

1. **Create Work Branch**: `git checkout -b work/STOR-123`
2. **Create Scratch Org**: `sf org create scratch -f config/project-scratch-def.json`
3. **Push Source**: `sf project deploy start`
4. **Develop & Test**: Iterative development with local testing
5. **Commit to Work Branch**: Triggers basic validation
6. **Create Pull Request**: Code review process
7. **Squash Merge to Main**: Triggers full CI pipeline

## CI/CD Pipeline Architecture

### Continuous Integration (CI) - On Merge to Main

**Trigger**: Every merge to main branch

**Pipeline Steps**:

1. **Source Validation**
   - Code quality checks (PMD, ESLint)
   - Metadata format validation
   - Dependency analysis

2. **Multi-Edition Package Testing**
   - Build unlocked package version
   - **Parallel installation** across 4 edition scratch orgs:
     - Developer Edition
     - Professional Edition  
     - Enterprise Edition
     - Unlimited Edition
   - Run full test suite on each edition
   - Validate package installation success

3. **Documentation Publishing**
   - Build internal documentation site using MkDocs
   - Deploy to internal documentation hosting
   - Include private/internal docs from `docs/` folder

4. **Artifact Storage**
   - Store unlocked package version for future reference
   - Archive test results and coverage reports

### Continuous Deployment (CD) - Gated Release Process

#### Phase 1: Release Candidate Creation

**Trigger**: Manual GitHub Actions workflow dispatch

**Release Manager Gate Process**:

1. **Analysis Phase**:
   - Analyze all commits since last release
   - Run automated breaking change detection (hints only)
   - Generate comprehensive release summary report
   - Identify potential compatibility issues

2. **Release Manager Review**:
   - Present formatted analysis via GitHub Actions interface
   - Show potential breaking changes with confidence levels
   - Display conventional commit markers from developers
   - Provide version recommendations (major/minor/patch)

3. **Version Selection**:
   - Release manager selects final version via GitHub UI dropdown
   - Options: major (X.0.0), minor (X.Y.0), patch (X.Y.Z)
   - System automatically creates `vX.Y.Z-rc1` tag

4. **RC Pipeline Execution**:
   - Build beta managed package version
   - Install on all 4 edition scratch orgs in parallel
   - Execute comprehensive test suite
   - Validate package installation and functionality

5. **Release Gate**:
   - Pipeline pauses for manual approval
   - Release manager reviews test results
   - **Pass**: Creates `vX.Y.Z` tag on same commit
   - **Fail**: Address issues and create new RC tag (rc2, rc3, etc.) or new version RC if breaking changes discovered

#### Phase 2: Production Release

**Trigger**: Creation of `vX.Y.Z` tag (from approved RC)

**Release Pipeline Steps**:

1. **Production Package Build**:
   - Create production managed package version
   - Generate package installation URL
   - Create release notes from commit history

2. **External Documentation**:
   - Build public documentation site using MkDocs
   - Filter out internal/private documentation
   - Deploy to external documentation hosting
   - Update API documentation and user guides

3. **AppExchange Preparation** (Future Research):
   - Package metadata validation for AppExchange requirements
   - Automated submission preparation
   - License and compliance validation
   - *Note: Specific AppExchange automation requires research*

4. **Release Communication**:
   - GitHub release creation with changelog
   - Package version availability notification
   - Customer communication templates

#### Tag Management Strategy

**Tag Retention**: All RC and release tags are preserved for audit trail

**RC Failure Scenarios**:

- **Minor Issues**: Create incremental RC tags (`v1.3.0-rc2`, `v1.3.0-rc3`)
- **Breaking Changes Discovered**: Create new major version RC (`v2.0.0-rc1`)
- **Version Change Needed**: Create appropriate new version RC

**Benefits**:

- Complete audit trail of all release attempts
- Historical record of what was tested and when
- Easier debugging of pipeline and testing issues
- Standard practice for release management

## Pipeline Reference Implementation

### Starting Point: Opera Workspace Tab Manager

**Reference Repository**: `opera-workspace-tab-manager` (user's GitHub repo)

This repository contains foundational GitHub Actions pipeline patterns that can be adapted for Salesforce 2GP development.
Key adaptations needed:

**Current Patterns to Adapt**:

- Manual workflow dispatch for release creation
- Automated version tagging
- Multi-step pipeline with gates
- Documentation publishing automation

**Salesforce-Specific Additions Required**:

- Salesforce CLI integration and authentication
- Scratch org creation and management
- Multi-edition testing matrix
- Package version creation and installation
- Metadata validation and deployment
- Test execution and coverage reporting

**Implementation Plan**:

1. Use existing pipeline structure as foundation
2. Replace generic build steps with Salesforce CLI commands
3. Add parallel matrix strategy for multi-edition testing
4. Integrate Salesforce authentication and Dev Hub connectivity
5. Add package version management workflows

## Technical Implementation Details

### Required GitHub Secrets

**Salesforce Authentication**:

- `SFDX_AUTH_URL`: Dev Hub authentication URL for CI/CD
- `DEVHUB_CONSUMER_KEY`: Connected app consumer key
- `DEVHUB_PRIVATE_KEY`: JWT private key for authentication

**Documentation Publishing**:

- `DOCS_DEPLOY_TOKEN`: Authentication for documentation site deployment
- `INTERNAL_DOCS_URL`: Internal documentation hosting endpoint
- `EXTERNAL_DOCS_URL`: Public documentation hosting endpoint

### Project Configuration Files

**sfdx-project.json**:

```json
{
  "packageDirectories": [
    {
      "path": "src",
      "default": true,
      "package": "Storacle",
      "versionName": "ver 1.0",
      "versionNumber": "1.0.0.NEXT",
      "definitionFile": "config/project-scratch-def.json"
    }
  ],
  "name": "storacle",
  "namespace": "strcl",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "60.0"
}
```

**Multi-Edition Scratch Org Definitions**:

- `config/developer-scratch-def.json`
- `config/professional-scratch-def.json`
- `config/enterprise-scratch-def.json`
- `config/unlimited-scratch-def.json`

### Documentation Strategy

**MkDocs Configuration**:

- Material theme for professional appearance
- Mermaid diagram support for architecture documentation
- Search functionality for comprehensive docs
- Mobile-responsive design

**Documentation Organization**:

```text
docs/
├── public/          # External customer documentation
│   ├── user-guide/
│   ├── api-reference/
│   └── installation/
├── internal/        # Private development documentation
│   ├── architecture/
│   ├── development/
│   └── operations/
└── mkdocs-public.yml   # Config for external docs
└── mkdocs-internal.yml # Config for internal docs
```

## Monitoring and Quality Assurance

### Breaking Change Detection

**Automated Analysis (Hints Only)**:

- Metadata field removal detection
- API signature changes
- Custom setting structure modifications
- Permission requirement changes

**Developer-Driven Indicators**:

- Conventional commit markers (`feat!:`, `BREAKING CHANGE:`)
- Pull request labels and descriptions
- Code review breaking change discussions

**Release Manager Decision Process**:

- Review all available breaking change indicators
- Consider customer impact and upgrade complexity
- Make final versioning decision with full context
- Document breaking changes in release notes

### Post-Release Monitoring (Future Research)

**Package Analytics**:

- Installation success/failure rates
- Version adoption tracking
- Customer org compatibility monitoring

**Error Telemetry**:

- Anonymous usage analytics
- Runtime error reporting
- Performance metrics collection

**Customer Feedback Channels**:

- GitHub issues integration
- Support portal connections
- Community feedback aggregation

### Rollback and Recovery

**Forward-Fix Strategy**:

- Salesforce managed packages cannot be downgraded
- All fixes must be forward-compatible
- Emergency hotfix process for critical issues

**Hotfix Process**:

- Fast-track minor version releases
- Abbreviated testing for critical security fixes
- Expedited release approval process

## Research Items for Implementation

### High Priority Research

1. **Salesforce Metadata Compatibility Analysis**:
   - Tools and techniques for automated breaking change detection
   - Metadata comparison between package versions
   - Customer impact assessment methods

2. **AppExchange Publishing Automation**:
   - AppExchange Partner API capabilities
   - Automated submission and approval processes
   - Compliance validation automation

3. **Package Installation Telemetry**:
   - Anonymous usage tracking best practices
   - Customer org monitoring without privacy violations
   - Performance metrics collection strategies

### Implementation Sequence

**Phase 1: Foundation**:

- Set up Dev Hub with namespace registration
- Configure basic GitHub Actions pipelines
- Implement single-edition scratch org testing

**Phase 2: Multi-Edition Testing**:

- Implement parallel 4-edition testing matrix
- Add comprehensive test automation
- Integrate breaking change detection hints

**Phase 3: Release Management**:

- Build release candidate creation workflow
- Implement manual approval gates
- Add automated tagging and versioning

**Phase 4: Production Release**:

- Complete production release pipeline
- Implement documentation publishing
- Add monitoring and analytics

**Phase 5: Enhancement**:

- AppExchange automation research and implementation
- Advanced telemetry and monitoring
- Customer communication automation

## Success Metrics

**Development Efficiency**:

- Time from feature start to production release
- Automated test coverage percentage (target: 95%+)
- Pipeline success rate (target: 98%+)

**Quality Assurance**:

- Customer installation success rate (target: 99%+)
- Post-release critical bugs (target: <1 per release)
- Breaking change communication accuracy

**Release Management**:

- Release candidate approval time
- Emergency hotfix deployment time
- Documentation currency and accuracy

This comprehensive development and build environment strategy ensures reliable, high-quality releases while maintaining efficient development workflows and comprehensive customer compatibility testing.
