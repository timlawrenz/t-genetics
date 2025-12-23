# Change: Nest Alleles Under Chromosomes (JSON API)

## Why
`Allele` is always owned by a `Chromosome` (`belongs_to :chromosome`).
The current JSON API exposes top-level `/alleles` endpoints, but creating an allele via JSON is not practical because it requires `inheritable_type` and `inheritable_id` (internal implementation detail) and we do not expose endpoints to create those inheritable records.

For an MCP/LLM integration, we want a small set of tools that reflect the domain:
- create/manage chromosomes
- create/manage alleles *within* a chromosome, using the existing `Allele.new_with_*` helpers

## What Changes
- Replace top-level allele endpoints with nested endpoints under a chromosome:
  - `GET /chromosomes/{chromosome_id}/alleles`
  - `POST /chromosomes/{chromosome_id}/alleles`
  - `GET /chromosomes/{chromosome_id}/alleles/{id}`
  - `PATCH /chromosomes/{chromosome_id}/alleles/{id}`
  - `DELETE /chromosomes/{chromosome_id}/alleles/{id}`
- Update the JSON payload for creating alleles to be **typed** and not leak `inheritable_*` internals.
- Update rswag documentation + committed OpenAPI artifact to reflect the new nested endpoints.

## Proposed Request Shape (JSON)
`POST /chromosomes/{chromosome_id}/alleles`

```json
{
  "allele": {
    "name": "legs",
    "type": "integer",
    "minimum": 1,
    "maximum": 50
  }
}
```

Supported types:
- `integer` → requires `minimum`, `maximum`
- `float` → requires `minimum`, `maximum`
- `boolean` → no additional fields
- `option` → requires `choices` (array)

## Compatibility / Breaking
- Since there are no external consumers yet, this change removes the top-level `/alleles` routes rather than deprecating them.

## Risks / Trade-offs
- Removing `/alleles` is a breaking change for any undocumented local usage (mitigate by updating rswag docs and any internal callers/tests).
- Typed payload validation must be explicit to avoid confusing error responses.
