## Context
`Allele` is a delegated type wrapper around inheritable records (`Alleles::Integer`, `Alleles::Float`, `Alleles::Boolean`, `Alleles::Option`). The app already provides ergonomic constructors in `Allele`:
- `new_with_integer`, `new_with_float`, `new_with_boolean`, `new_with_option`

## Goals
- Make the JSON API match the domain: alleles live under chromosomes.
- Avoid exposing internal `inheritable_type` / `inheritable_id` in the public JSON API.
- Keep the implementation small by reusing existing helper constructors.

## Non-Goals
- Introducing standalone endpoints for `integer_alleles` / `float_alleles` tables.
- Redesigning the data model.

## Decisions
### Nested routing
All allele operations are scoped by `chromosome_id`.

### Typed request payloads
Use a `type` discriminator with type-specific parameters.

### Update semantics
- Allow updating `name` and **type-specific constraints** within the existing allele type:
  - `Integer`/`Float`: `minimum`, `maximum`
  - `Option`: `choices`
  - `Boolean`: no constraints
- The system SHALL NOT allow changing an allele’s `type` after creation (return a 4xx with a clear error).

## Open Questions
- None.

## Decisions (Additional)
- The typed create endpoint SHALL accept `type` values as `Integer|Float|Boolean|Option`.
- Bulk creation (create chromosome + alleles in one request) is out of scope for this change.
