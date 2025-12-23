## Context
TGenetics exposes JSON-capable Rails endpoints alongside HTML views. We want a single source of truth for the JSON interface that stays in sync with implementation.

## Goals
- Generate an OpenAPI document from request specs (executable documentation).
- Make docs easily discoverable for developers (Swagger UI).
- Document the existing API as-is (no behavior change in this proposal).

## Non-Goals
- Adding authentication/authorization to the API.
- Changing endpoint semantics or payload shapes.

## Decisions
### Use rswag-specs with RSpec request specs
- We will encode the API contract in rswag request specs so the OpenAPI doc is test-derived.

### Initial doc version: v1
- Publish docs under `v1` even if we only have one version today, to allow safe evolution later.

### Serving docs
- Mount `rswag-ui` and `rswag-api` routes in Rails and serve Swagger UI at a stable path (commonly `/api-docs`).
- Commit generated OpenAPI artifacts under `swagger/v1/` so the UI can serve stable, versioned docs.

### Payload reality over idealization
- The OpenAPI spec will match current behavior (e.g., what `to_hsh` returns) unless we explicitly introduce an API evolution change.

## Risks / Mitigations
- Drift risk: Require rswag specs to be updated with endpoint changes; consider CI gating on rswag spec generation.
- Ambiguous “API vs UI JSON”: Keep the spec explicit about what is supported and what is not.

## Open Questions
- Do we want to add an `Accept: application/json` convention and document it explicitly?
