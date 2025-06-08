# Product Requirements Document: T-Genetics Gem (Revised)

**1. Introduction**

This document outlines the requirements for converting the existing `t-genetics` Ruby on Rails application into a Ruby gem. The primary goal is to create a reusable library that encapsulates the core genetic algorithm experimentation logic, making it easily integrable into other Ruby on Rails applications. The gem will expose its functionality solely through `gl_command` interfaces, removing all web-specific components like views, controllers, helpers, and authentication/authorization layers.

**2. Goals**

*   **Decouple Core Logic:** Extract the genetic algorithm engine, models, and related functionalities from the web application interface.
*   **Create a Reusable Gem:** Package the core logic as a standard Ruby gem (potentially a Rails Engine) that can be included as a dependency in other Rails projects.
*   **Standardized Interface:** Expose all gem functionalities exclusively through `gl_command`s, adhering to the conventions outlined in `CONVENTIONS.md`.
*   **Maintain Data Persistence:** Retain the existing database schema and migrations, allowing for future schema evolution through new migrations within the gem.
*   **Simplified Installation:** Provide a mechanism (e.g., a Rake task) for new consumers of the gem to set up the necessary database tables.
*   **Adherence to Ruby Gem Standards:** Structure the gem according to common Ruby gem conventions, with all primary code (including models and commands) residing in the `lib/` directory.

**3. Non-Goals**

*   **Web Interface:** The gem will not provide any web-based UI (views, controllers, helpers).
*   **Authentication/Authorization:** All existing authentication and authorization logic will be removed. Consumers of the gem will be responsible for their own access control.
*   **Application-Specific Business Logic:** Any business logic not directly related to the core genetic algorithm experimentation toolset should be excluded.
*   **Maintaining `app/` directory structure:** The gem will follow standard gem conventions, primarily utilizing the `lib/` directory.
*   **Immediate Configuration System:** Implementing a dedicated configuration system for global parameters is deferred. Existing global parameters will be handled as-is with the expectation of being moved to a model (e.g., 'experiment settings') in a future iteration.
*   **Full Overhaul of Specs:** While tests need to pass in the new gem structure, a complete rewrite of all specs to strictly adhere to every testing guideline in `CONVENTIONS.md` is out of scope for this initial conversion.
*   **Immediate Implementation of N+1 Specs:** While important, adding new N+1 query prevention specs is deferred for this initial conversion.

**4. Functional Requirements**

*   **FR1: Gem Structure**
    *   The gem's codebase, including ActiveRecord models, `gl_command`s, and other core logic, will reside primarily within the `lib/` directory.
    *   The `app/` directory (and its subdirectories like `controllers`, `views`, `helpers`, `assets`, `channels`, `javascript`, `jobs`, `mailers`) will be removed from the gem's packaged code.
*   **FR2: `gl_command` Interface**
    *   All functionalities of the gem must be accessible via `gl_command`s.
    *   Existing `gl_command`s will be moved to an appropriate location within `lib/` and reviewed/refactored if necessary to ensure they are suitable for a gem context.
    *   Commands must adhere to the naming and encapsulation principles in `CONVENTIONS.md`.
*   **FR3: Database Migrations**
    *   Existing database migrations must be preserved and included in the gem.
    *   The gem must provide a mechanism for consumers to run its migrations. This will likely be a Rake task (e.g., `your_gem_name:install:migrations`), especially if not implemented as a Rails Engine which can handle this automatically.
    *   Future versions of the gem must be able to include new migrations to evolve the database schema.
    *   Migrations must only contain schema changes, as per `CONVENTIONS.md`.
*   **FR4: Installation Task**
    *   A Rake task (or similar mechanism, potentially handled by a Rails Engine) shall be provided to allow consuming applications to:
        *   Copy and run the gem's migrations.
        *   Perform any other one-time setup required for the gem to function correctly.
*   **FR5: Dependencies**
    *   The gem will declare its dependencies, including `rails` (as it relies on ActiveRecord and migrations) and `gl_command`.
    *   Minimize other external dependencies where possible.
*   **FR6: Documentation**
    *   The gem's `README.md` will be updated to reflect its new nature as a library.
    *   It will include clear instructions on:
        *   Installation and setup (including running migrations).
        *   Usage of the exposed `gl_command`s.
        *   How to contribute or extend the gem.
*   **FR7: Testing**
    *   Existing relevant tests (unit tests for commands, models, and core logic) will be migrated and adapted for the gem structure. The primary goal is to ensure these tests pass.
    *   Controller specs will be removed.
    *   The existing system spec `spec/system/actions_spec.rb` (or its equivalent adapted for the gem structure, focusing on command execution flows) should be preserved as the primary integration test for verifying the core user journey of creating a valid Chromosome.
    *   Other request/system specs will be removed or significantly refactored if their core logic can be tested by directly invoking `gl_command`s.
    *   The testing strategy for *new* tests post-conversion should align with `CONVENTIONS.md`, but refactoring all existing tests to perfectly match is out of scope for this initial migration.

**5. Technical Considerations**

*   **Namespacing:** All modules and classes within the gem should be properly namespaced to avoid conflicts with consuming applications (e.g., `TGenetics::SomeModule::SomeClass`).
*   **Rails Engine:** Strongly consider packaging the gem as a **Rails Engine**. This will simplify tasks like managing migrations, Rake tasks, and potentially provide a clear path for future enhancements like a mountable admin interface.
*   **Dependency Management:** Use a `.gemspec` file to manage the gem's metadata, dependencies, and files.
*   **Versioning:** Adhere to semantic versioning (SemVer) for the gem.

**6. Future Considerations (Out of Scope for Initial Conversion)**

*   Implementing a dedicated configuration system (e.g., an initializer or moving global parameters to an 'experiment settings' model).
*   Providing default Rake tasks for common genetic algorithm operations beyond installation.
*   Extensibility points for users to plug in their own fitness functions or genetic operators more easily.
*   Compatibility with other Ruby frameworks beyond Rails.
*   Implementing comprehensive N+1 query prevention specs.
*   A full refactor of all existing specs to strictly adhere to `CONVENTIONS.md`.
*   Providing a mountable admin interface (potentially leveraging the Rails Engine structure).

**7. Adherence to `CONVENTIONS.md`**

*   The conversion process will aim to maintain adherence to `CONVENTIONS.md` where feasible for the new gem structure. Specifically:
    *   Use of `GLCommand` for business logic.
    *   Command naming conventions.
    *   Single responsibility for commands.
    *   Implementation of `rollback` logic where appropriate (for existing commands that have it, and new ones).
    *   Migration scope limited to schema changes.
*   It is understood that full adherence, especially regarding the existing test suite, is an ongoing effort and not a strict blocker for this initial gem conversion.

This revised PRD incorporates your feedback. Let me know your thoughts!
