# Salesforce Development Principles

## Platform-Specific Architecture

### Salesforce Platform Patterns

- Follow Salesforce naming conventions: PascalCase for objects and fields
- Use package namespaces consistently: managed packages use double underscores (`myapp__Object__c`), non-managed internal unlocked packages use pseudo-namespaces with single underscores (`core_Object__c`)
- Leverage platform features: hierarchical custom settings, roll-up summaries, formula fields
- Avoid noise words in field names - keep them descriptive but concise
- Use Master-Detail relationships for data integrity and performance benefits

### Salesforce Code Quality Tools

- **Use Prettier** for consistent code formatting across all files
- **Use Salesforce Code Analyzer** for static analysis and best practices enforcement
- **Use cspell** for spelling checks in code, comments, and documentation
- **Apply ESLint with LWC-specific plugins**: Use `@lwc/eslint-plugin-lwc` and `@salesforce/eslint-config-lwc` (v4.0+ for ESLint v9 support, v3.x for older ESLint versions)
- **Configure tools to run automatically** during development and in CI/CD pipelines

### Governor Limits and Performance

- Design for bulkification from the start - never assume single record processing
- Use selective queries with proper WHERE clauses and indexed fields
- Minimize SOQL queries in loops - collect IDs and query in batches
- Leverage platform caching (hierarchical custom settings, platform cache)
- Use asynchronous processing (Batch, Queueable, Future) for large operations

### Data Model Design

- Choose appropriate relationship types: Master-Detail for tight coupling, Lookup for flexibility
- Use External IDs for integration and upsert operations
- Consider query patterns when designing indexes and field types
- Store calculated values in bytes or base units for mathematical precision
- Use meaningful record names instead of auto-numbers when possible

## Code Organization and Structure

### Apex Development Standards

- Separate business logic from trigger handlers using service classes
- Use dependency injection or factory patterns for testability
- Implement proper exception handling with custom exception types
- Follow Salesforce security best practices: with sharing classes
- Use constants for literal values and configuration

### Lightning Development

- Choose Lightning Web Components over Aura for new development
- Follow component composition patterns - small, reusable components
- Handle errors gracefully with user-friendly messages
- Use Lightning Data Service when appropriate for automatic caching
- Implement proper loading states and accessibility features
- Build Jest tests for all Lightning Web Components
- **Use official LWC ESLint tools**: Install `@lwc/eslint-plugin-lwc` and `@salesforce/eslint-config-lwc` with configuration levels:
  - **base**: Prevents common LWC pitfalls and enforces platform restrictions
  - **recommended**: Prevents JavaScript pitfalls and enforces best practices
  - **extended**: Restricts slow language features for older browser compatibility
- **Lightning Web Security**: Use `@locker/eslint-config-locker` for components running in LWS
- **Mobile/Offline development**: Apply mobile-specific ESLint rules for offline-capable LWCs

### Integration Patterns

- Use platform events for loosely coupled system communication
- Implement proper callout patterns with timeout and error handling
- Use Named Credentials for external authentication
- Design for API rate limits and implement exponential backoff
- Log integration failures with sufficient context for debugging

## Salesforce-Specific Security

### Sharing and Security Model

- Understand and implement proper sharing rules and security
- Use field-level security appropriately for data protection
- Test with different user profiles and permission sets
- Avoid hardcoding user IDs or organization-specific values
- Implement proper validation rules for data quality

### Permissions and Access Control

- Follow principle of least privilege for system access
- Use permission sets for granular access control
- Test functionality with minimal required permissions
- Document required permissions for deployment
- Consider using platform events for elevated privilege operations

## Testing and Quality Assurance

### Apex Testing Strategy

- Achieve minimum 75% code coverage, target 85% for managed packages
- Use test data factories for consistent, realistic test data
- Test both positive and negative scenarios
- Mock external callouts and dependencies
- Test with different user contexts and data visibility

### Deployment and Release Management

- Use source-driven development with version control
- Implement proper CI/CD pipelines with automated testing
- Use scratch orgs for feature development and testing
- Plan for data migration and configuration changes
- Test deployments in staging environment before production

## Salesforce Data Management

### Storage and Performance Optimization

- Understand Salesforce storage calculations (per-record storage factors)
- Use appropriate data types for storage efficiency
- Implement data archival strategies for large data volumes
- Monitor storage usage and plan for capacity growth
- Use selective deletion and archival for data lifecycle management

### Configuration vs. Code

- **First priority: Avoid triggered actions entirely** when possible through careful data model design
- **When triggered actions are necessary**: Keep all triggered customizations on a single object in the same type (flows vs code) to maintain context
- **Code trigger consistency**: Once using code triggers on an object, implement all logic for that object in code to keep context simple
- **Package development**: Use code triggers instead of flows for better testability and maintainability
- **Open source solutions**: Look for existing open source solutions to common problems before building custom implementations
- **Complex packages**: Consider implementing dependency injection, mocking, and unit of work patterns from open source libraries
- Document the reasoning for custom code vs. configuration choices
- Keep customizations maintainable and upgradeable

## Package Development (Managed/Unlocked)

### Package Design Principles

- Design for multi-tenancy from the beginning
- Avoid org-specific assumptions in code and configuration
- Use namespace prefixes consistently throughout the package
- Implement proper upgrade and versioning strategies
- Plan for backward compatibility in API changes

### AppExchange Preparation

- Follow AppExchange security review requirements
- Implement comprehensive error handling and user experience
- Provide proper documentation and support materials
- Test across different Salesforce editions and configurations
- Plan for partner program requirements and business model

## Salesforce DevOps

### Environment Management

- Use separate development, testing, and production environments
- Implement proper data masking for non-production environments
- Use metadata API for deployments and configuration management
- Maintain environment parity to reduce deployment issues
- Document environment-specific configurations

### Monitoring and Diagnostics

- Use Salesforce's built-in debugging and monitoring tools
- Implement custom logging for business-critical operations
- Monitor API usage and governor limit consumption
- Set up alerts for system failures and performance issues
- Use platform events for real-time monitoring capabilities

## Business Process Integration

### Salesforce Ecosystem Awareness

- Understand common Salesforce usage patterns and business processes
- Design solutions that integrate well with standard Salesforce functionality
- Consider impact on existing workflows and user experience
- Plan for common customizations and extensions
- Document integration points and dependencies

### User Experience and Adoption

- Design intuitive interfaces that follow Salesforce UX guidelines
- Provide appropriate help text and error messages
- Consider mobile experience and responsive design
- Plan for user training and change management
- Implement progressive disclosure for complex features
