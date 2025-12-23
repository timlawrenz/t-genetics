# Change: Add Rswag API Documentation

## Why
We currently have JSON-capable Rails endpoints for chromosomes/alleles/generations/organisms (including a `procreate` lifecycle step), but there is no canonical, discoverable, versioned API contract.
Adding `rswag` lets us generate an OpenAPI spec directly from request specs, keeping documentation and behavior in sync.

## What Changes
- Add the `rswag` gem suite (`rswag-api`, `rswag-ui`, `rswag-specs`) and baseline configuration.
- Serve interactive API docs (Swagger UI) for the app’s JSON endpoints.
- Document the **entire existing** JSON interface in `rswag` request specs and generate an OpenAPI document from CI/test runs.
- Define a clear versioning strategy for the docs (initially `v1`).

## Scope (Initial)
- Document existing **JSON** endpoints only (no behavior changes).
- HTML responses are explicitly out of scope.
- Generated OpenAPI artifacts (e.g., `swagger/v1/swagger.json` and/or `swagger/v1/swagger.yaml`) SHALL be committed to git.

## Out of Scope (for this change)
- Introducing new API endpoints, auth, or breaking changes.
- Reworking response payloads (e.g., adding ids/fitness to `Organism#to_hsh`) unless required to accurately represent existing behavior.

## Impact
- **New dependency:** `rswag` (test + runtime, depending on configuration).
- **New routes:** Swagger UI / OpenAPI endpoints (typically `/api-docs` and `/api-docs/v1/swagger.yaml|json`).
- **Testing:** Adds/extends request specs to cover and document the current API.
- **Developer experience:** Enables quick discovery of API and a living contract.

## Risks / Trade-offs
- Documentation can drift if endpoints are changed without updating `rswag` specs (mitigation: require rswag specs in CI).
- The current JSON payloads may be “UI-shaped” rather than “API-shaped” (e.g., `Organism#to_hsh` lacks ids); docs will reflect reality unless we explicitly choose to evolve the API.
