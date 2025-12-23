## 1. Add Rswag
- [ ] 1.1 Add `rswag-api`, `rswag-ui`, `rswag-specs` to the Gemfile (appropriate groups)
- [ ] 1.2 Run installation generator(s) and commit initial config (swagger root, rswag-specs helper)
- [ ] 1.3 Mount rswag routes (e.g., `/api-docs`) and verify in development

## 2. Define OpenAPI Organization
- [ ] 2.1 Choose initial API doc versioning (`v1`)
- [ ] 2.2 Define global metadata (title, description, servers)
- [ ] 2.3 Define shared schemas/components for common models and errors

## 3. Document Existing Endpoints (Rswag Specs)
- [ ] 3.1 Chromosomes: index/show/create/update/destroy (JSON)
- [ ] 3.2 Alleles: index/show/create/update/destroy (JSON)
- [ ] 3.3 Generations: index/show (JSON)
- [ ] 3.4 Generations: `POST /chromosomes/{chromosome_id}/generations/{id}/procreate` (JSON)
- [ ] 3.5 Organisms: index/show/update fitness (JSON)
- [ ] 3.6 Use `spec/system/actions_spec.rb` as a reference for “real-life” lifecycle flows and example data (but implement rswag as request specs)

## 4. Make It Durable
- [ ] 4.1 Generate OpenAPI artifacts via rswag (e.g., `bundle exec rspec spec/requests --format Rswag::Specs::SwaggerFormatter`)
- [ ] 4.2 Commit generated artifacts under `swagger/v1/` to git
- [ ] 4.3 Add/confirm a CI/test step that regenerates artifacts and fails if the committed artifacts are out of date
- [ ] 4.4 Add a short README section describing how to view docs locally

## 5. Validation
- [ ] 5.1 Run `bundle exec rspec` including rswag specs
- [ ] 5.2 Confirm Swagger UI renders and operations match actual behavior
