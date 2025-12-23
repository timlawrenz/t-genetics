## ADDED Requirements

### Requirement: OpenAPI documentation for existing REST endpoints
The system SHALL provide an OpenAPI (Swagger) specification that documents the existing JSON endpoints for chromosomes, alleles, generations, and organisms.

#### Scenario: Developer views API docs locally
- **WHEN** the developer runs the Rails server in development
- **THEN** a Swagger UI page is accessible (e.g., at `/api-docs`)
- **AND THEN** the UI references the generated OpenAPI document (e.g., `v1`)

#### Scenario: Documentation stays in sync with behavior
- **WHEN** request specs are executed in CI
- **THEN** the OpenAPI document is generated from `rswag` specs
- **AND THEN** the generated documentation reflects actual request/response shapes and status codes

### Requirement: Document the multi-generation lifecycle endpoints
The system SHALL document the existing endpoints required to drive evolution across generations, including the generation procreation action.

#### Scenario: Document procreation endpoint
- **WHEN** the API documentation is generated
- **THEN** it includes `POST /chromosomes/{chromosome_id}/generations/{id}/procreate`
- **AND THEN** it describes the response as the newly created offspring generation
