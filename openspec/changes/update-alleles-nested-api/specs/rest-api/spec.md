## MODIFIED Requirements

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

## ADDED Requirements

### Requirement: Alleles are managed within a chromosome scope
The system SHALL expose JSON endpoints for listing, creating, showing, updating, and deleting alleles scoped to a chromosome.
The system SHALL allow updating allele constraints within the allele’s existing type, and SHALL NOT allow changing the allele type after creation.

#### Scenario: List alleles for a chromosome
- **WHEN** a client requests `GET /chromosomes/{chromosome_id}/alleles`
- **THEN** the system returns a JSON array of alleles belonging to that chromosome

#### Scenario: Create a typed integer allele
- **WHEN** a client posts to `POST /chromosomes/{chromosome_id}/alleles` with `type=integer` and `minimum`/`maximum`
- **THEN** the system creates the allele using the equivalent of `Allele.new_with_integer(...)`
- **AND THEN** the allele is associated with the chromosome

#### Scenario: Reject missing type-specific fields
- **WHEN** a client posts to `POST /chromosomes/{chromosome_id}/alleles` with `type=option` but without `choices`
- **THEN** the system returns a 4xx response describing the validation error

## REMOVED Requirements

### Requirement: Top-level alleles endpoints
The system SHALL NOT expose top-level JSON endpoints for allele management (e.g., `/alleles`) because alleles are always owned by a chromosome.

#### Scenario: Prevent access to top-level alleles
- **WHEN** a client requests `GET /alleles`
- **THEN** the route is not available
