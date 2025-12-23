# Project Context

## Purpose
TGenetics is a Ruby on Rails application/framework for exploring genetic algorithms and evolutionary computation.
It models chromosomes/alleles/values, manages generations and organisms, and provides commands for selection, crossover, mutation, and experiment-driven evolution.

## Tech Stack
- **Language/Runtime:** Ruby 3.4.5
- **Web framework:** Rails 8.1.1
- **Database:** PostgreSQL (`config/database.yml`)
- **UI:** Server-rendered Rails views + **ViewComponent** (`app/components`) + **HAML** (`haml-rails`)
- **Frontend tooling:** Hotwire (**turbo-rails**, **stimulus-rails**) + **importmap-rails**
- **Styling:** **tailwindcss-rails** (+ Tailwind plugins in `package.json`: forms, typography, aspect-ratio, container-queries)
- **Service/business logic:** `gl_command` commands (see `app/commands`)
- **Modularity:** Packwerk, with domain packs under `packs/`
- **Observability:** Sentry (`sentry-ruby`, `sentry-rails`; `sentry-sidekiq` present via lockfile)

## Project Conventions

### Code Style
- Enforce style with **RuboCop** (`.rubocop.yml`) including `rubocop-rails`, `rubocop-rspec`, and `rubocop-performance`.
- **Max line length:** 100 (`Layout/LineLength`).
- Prefer small, single-purpose objects/methods.
- Commands (see below) should be named with a leading verb (e.g., `CreateUser`, `SendEmail`).

### Architecture Patterns
- **Thin controllers:** controllers should focus on auth/authorization, input validation, calling a command, and mapping results to HTTP responses (see `CONVENTIONS.md`).
- **Use `GLCommand` for business logic:** model multi-step workflows as command chains; implement `rollback` where appropriate.
- **Rollback semantics:** if a command chain fails, previously executed commands’ `rollback` methods are invoked in reverse order (design commands accordingly).
- **ViewComponents for UI:** build reusable UI in `app/components`.
- **Packwerk boundaries:** new domain logic should live in a pack under `packs/` when it makes sense; keep dependencies explicit and minimal.
- **Migrations:** schema-only migrations; data backfills/manipulation go in separate rake tasks. Follow safe multi-phase column changes (Add column → write code → backfill task → add constraint → switch reads → drop old column).

### Testing Strategy
(From `CONVENTIONS.md` + Gemfile)
- **RSpec** is the primary test framework.
- **No controller specs.**
- Prefer **isolated unit tests** for models, commands, and POROs; mock DB/external calls as needed and test rollback logic.
- Use **request specs** mainly to verify authorization behavior and that the right command is called with correct args; keep them thin.
- Keep **full DB/integration tests** limited to critical end-to-end flows (especially command chains).
- Add **N+1 prevention tests** using `n_plus_one_control` where relevant.
- System/browser testing is available via Capybara + Selenium/Webdrivers.

### Git Workflow
- Default assumption: feature branches off `main`, PRs are small and focused.
- **TODO:** document your preferred branching/merging policy (merge vs squash vs rebase) and any commit message conventions.

## Domain Context
Key concepts (see `README.md`):
- **Chromosome** composed of **Alleles** (Float/Integer/Boolean/Option) that define the search space.
- **Generation** contains a population of **Organisms**.
- **Organism** has **Values** corresponding to each allele; values can mutate.
- Evolution operations are implemented as commands (e.g., fitness evaluation, selection/picking, procreation/crossover/mutation, new generation).
- The `packs/experiments` pack introduces **Experiment** runs and **PerformanceLog** feedback-driven evolution.

## Important Constraints
- Keep domain logic out of controllers; prefer commands and/or pack-local services.
- Treat command rollback behavior as part of correctness (especially for multi-step flows).
- Avoid N+1 queries in read paths; add tests when a query pattern is important.
- Prefer safe, multi-phase DB changes to support deploys without downtime.

## External Dependencies
- **PostgreSQL**
- **Sentry** for error reporting
- **Tailwind build/watch** via `tailwindcss-rails` (see `Procfile.dev`)
- **Selenium/Webdrivers** for system specs (if running browser tests locally/CI)
