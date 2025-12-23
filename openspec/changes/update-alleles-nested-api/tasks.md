## 1. Routing and Controllers
- [ ] 1.1 Remove top-level `resources :alleles` routes
- [ ] 1.2 Add nested routes: `resources :chromosomes do; resources :alleles; end`
- [ ] 1.3 Update/controller split:
  - Option A: new `Chromosomes::AllelesController`
  - Option B: reuse `AllelesController` but require `chromosome_id` and scope all lookups

## 2. Typed Allele Creation
- [ ] 2.1 Implement typed create using existing helpers in `app/models/allele.rb`:
  - `Allele.new_with_integer`, `new_with_float`, `new_with_boolean`, `new_with_option`
- [ ] 2.2 Define strong params for `type` + `minimum/maximum/choices`
- [ ] 2.3 Validate type-specific required fields and return consistent JSON errors (4xx)

## 3. Typed Allele Update
- [ ] 3.1 Allow updating `name` and type-specific constraints (`minimum`/`maximum` or `choices`) within the existing type
- [ ] 3.2 Disallow changing `type` after creation (return 4xx with a clear error)

## 4. Documentation
- [ ] 4.1 Update rswag specs to use nested allele endpoints
- [ ] 4.2 Regenerate and commit `swagger/v1/swagger.yaml`
- [ ] 4.3 Ensure `bundle exec rake rswag:verify` passes

## 5. Tests
- [ ] 5.1 Add request specs for typed allele creation for each type
- [ ] 5.2 Keep `spec/system/actions_spec.rb` as a reference flow; ensure new API can recreate the same allele set
