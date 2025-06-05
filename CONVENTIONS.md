NameError:
*   **Controller Responsibilities:** Controllers focus on auth (using **Pundit**), input validation, calling `GLCommand`, and handling command results.
*   **Avoid Domain Logic in Controllers:** Keep domain logic out of controllers; delegate it to `GLCommand`s or service layers.
*   **Use `GLCommand` for Business Logic:** Isolate and chain individual steps in business logic flows using the `gl_command` gem (https://github.com/givelively/gl_command).
    *   **Naming:** Command class names must start with a verb (e.g., `SendEmail`, `CreateUser`).
    *   **Encapsulation:** Minimize logic in controllers and workers; move complex logic into Commands.
    *   **Single Responsibility:** Each Command should have a small, single purpose.
    *   **Chaining:** Combine multiple Commands into a chain for complex, multi-step operations.
    *   **Rollback:** Commands can implement a `rollback` method to undo their actions.
    *   **Automatic Rollback on Failure:** If any command within a chain fails during execution, the `rollback` methods of all *previously successfully executed commands in that chain* will be automatically invoked in reverse order. Design commands and their `rollback` methods with this transactional behavior in mind.
*   **Testing Strategy:**
    *   **No Controller Specs:** Do not write controller specs.
    *   **Isolated Unit Tests:** Cover classes, methods, and `GLCommand`s with isolated unit tests (mocking DB/external calls, **including rollback logic**).
    *   **Request Specs:** Use request specs primarily to test auth (Pundit) and verify the correct `GLCommand` is called with correct args, asserting the HTTP response based on the mocked command outcome.
    *   **Limited Integration Specs:** Use a few integration tests (e.g., full-stack request specs hitting the DB) for critical end-to-end business flows only (**especially those involving command chains**).
    *   **N+1 Query Prevention:** Implement **N+1 tests** (using `n_plus_one_control`) for relevant data-fetching scenarios.
*   **Migration Scope:** Migrations must only contain schema changes. Use separate Rake tasks for data backfills/manipulation.
*   **Multi-Phase Column Addition:** Follow the safe multi-phase deployment process (Add Col -> Write Code -> Backfill Task -> Add Constraint -> Read Code -> Drop Old Col) when adding/replacing columns.
*   **For UI elements, utilize reusable ViewComponents located in `app/components`. Refer to the ViewComponent documentation (https://viewcomponent.org/) for best practices.**
*   **Organize code into domain-specific packs using Packwerk (https://github.com/Shopify/packwerk). New logic should ideally be encapsulated within a new or existing pack located in the `packs/` subfolder. Define clear pack boundaries and dependencies.**
*   *Consider impact on existing background job queues.*
