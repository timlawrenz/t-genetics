# Experiments Pack

This pack manages `Experiment` records, which are used to track and configure runs of genetic algorithms or evolutionary processes.

## Core Model: `Experiment`

The `Experiment` model is central to this pack. It encapsulates the setup and state of a specific evolutionary run.

### Key Attributes:

*   `chromosome_id`: A foreign key linking the experiment to a `Chromosome`. This defines the genetic structure being evolved.
*   `external_entity_id` & `external_entity_type`: A polymorphic association allowing an experiment to be linked to an external record in the system (e.g., a specific project, a user request, etc.). This provides context for why the experiment is being run.
*   `status`: A string field managed by AASM to track the current state of the experiment. Possible states are:
    *   `pending`: The initial state when an experiment is created.
    *   `running`: The experiment is actively in progress.
    *   `completed`: The experiment has finished successfully.
    *   `failed`: The experiment has finished due to an error or failure condition.
*   `current_generation_id`: A foreign key linking to the most recent `Generation` produced within this experiment. This allows tracking the progress of the evolutionary process.
*   `configuration`: A JSONB field to store various settings and parameters for the experiment. This could include:
    *   Population size
    *   Mutation rates
    *   Crossover strategies
    *   Selection mechanisms
    *   Termination conditions
    *   Any other parameters relevant to the specific genetic algorithm setup.
*   `created_at` & `updated_at`: Standard Rails timestamps.

### Purpose and Usage:

The `Experiment` model allows users to:

*   Define and persist different configurations for evolutionary runs.
*   Track the progress and status of ongoing or completed experiments.
*   Associate evolutionary runs with specific chromosomes and, optionally, other entities in the application.
*   Store results or key metrics indirectly by linking to the `current_generation` and its associated `Organism`s.

This model provides a way to organize and manage multiple instances of genetic algorithm executions, making it easier to compare results, reproduce experiments, and manage complex evolutionary studies.

## Supporting Model: `PerformanceLog`

The `PerformanceLog` model records each instance where an organism's genetic makeup (its values) is suggested for use, and the outcome of that suggestion.

### Key Attributes:

*   `experiment_id`: Foreign key to `Experiment`, linking the log entry to a specific experiment.
*   `organism_id`: Foreign key to `Organism`, identifying the organism whose values were suggested.
*   `suggested_at`: Timestamp indicating when the organism's values were suggested.
*   `outcome_recorded_at`: Timestamp indicating when the outcome of the suggestion was recorded (nullable).
*   `outcome_metrics`: JSONB field to store rich contextual data about the outcome (nullable).
*   `fitness_input_value`: A float value that might be used as an input to a fitness function or represents a direct performance measure (nullable).

### Purpose and Usage:

The `PerformanceLog` model is designed to:

*   Track how often and when specific organisms (and their genetic configurations) are chosen or suggested for a task.
*   Record the performance or outcome associated with using an organism's configuration.
*   Provide data for more detailed analysis of an experiment's progress, beyond simple generation-based fitness.
*   Help in understanding which genetic traits lead to successful outcomes in the context of the `external_entity` the experiment is tied to.

## Key Commands

### `Experiments::Setup`

This command initializes a new experiment.

*   **Purpose:** To create all necessary records for starting a new evolutionary run, including the initial `Generation` of `Organism`s.
*   **Inputs:**
    *   `external_entity`: A polymorphic ActiveRecord object to which the experiment is related (e.g., a project, a user task). (Required)
    *   `chromosome`: A pre-existing, persisted `Chromosome` record that defines the genetic structure for the experiment. (Required)
    *   `experiment_configuration`: An optional hash to store specific settings for the experiment (e.g., `{ population_size: 50 }`). If `population_size` is not provided, it defaults to 10.
*   **Output:**
    *   `experiment`: The newly created `Experiment` record, which will be linked to the provided `chromosome`, the `external_entity`, and a newly created initial `Generation` populated with organisms.
*   **Process:**
    1.  Validates that the provided `chromosome` is a persisted `Chromosome` record.
    2.  Creates an initial `Generation` (iteration 0) associated with the `chromosome`.
    3.  Populates this initial `Generation` with a number of `Organism`s (defaulting to 10, or as specified in `experiment_configuration[:population_size]`). Each `Organism` is created using `Organisms::Create`, which initializes its genetic `Value`s randomly based on the `Allele` definitions in the `chromosome`.
    4.  Creates an `Experiment` record, linking it to the `external_entity`, `chromosome`, the new `current_generation`, and storing any `experiment_configuration`. The `status` is automatically set to `pending` by AASM.
*   **Rollback:** If any step in the creation process fails (e.g., database save error), the entire operation is rolled back, ensuring no partial experiment setup is left behind. If this command is part of a larger chain of commands and a subsequent command fails, the `rollback` method of `Experiments::Setup` will destroy the created `Experiment` and its initial `Generation` (and associated `Organism`s via `dependent: :destroy` if configured). The input `Chromosome` is not affected by the rollback.

### `Experiments::RequestSuggestion`

This command selects an organism from an experiment's current generation for a "suggestion" (e.g., to be used in an external process) and logs this event.

*   **Purpose:** To choose an organism based on a defined strategy (MVP: least selected) and record that it has been suggested.
*   **Inputs:**
    *   `experiment`: An instance of the `Experiment` model. (Required)
*   **Outputs:**
    *   `organism`: The selected `Organism` instance.
    *   `performance_log`: The newly created `PerformanceLog` entry for this suggestion.
*   **Process:**
    1.  Identifies the `current_generation` of the provided `experiment`. Fails if no current generation exists or if it contains no organisms.
    2.  Selects an `Organism` from this generation. The MVP strategy is "least selected":
        *   For each organism in the current generation, it counts the number of existing `PerformanceLog` entries associated with *both* that specific organism *and* the current `experiment`.
        *   It then picks an organism (randomly, in case of ties) that has the minimum count of such logs. This prioritizes organisms that have been suggested fewer times for this particular experiment.
    3.  Creates a new `PerformanceLog` record, linking it to the `experiment` and the selected `organism`. The `suggested_at` timestamp is set to the current time.
    4.  If the `PerformanceLog` fails to save, the command fails.
    5.  Returns the selected `organism` and the new `performance_log`.
*   **Rollback:** If this command succeeds but a subsequent command in a chain fails, its `rollback` method will destroy the `PerformanceLog` record that was created.

### `Experiments::RecordOutcome`

This command records the outcome of a previously suggested organism, updating its `PerformanceLog` entry.

*   **Purpose:** To store the results or performance metrics associated with an organism that was suggested by `Experiments::RequestSuggestion`.
*   **Inputs:**
    *   `performance_log` or `performance_log_id`: An instance of `PerformanceLog` or the ID of the `PerformanceLog` entry to update. (Required)
    *   `fitness_input_value`: A `Float` representing a key performance indicator or fitness contribution from this suggestion. (Required)
    *   `outcome_metrics`: An optional hash containing any additional contextual data about the outcome (will be stored as JSONB).
*   **Outputs:**
    *   The `performance_log` context variable will contain the updated `PerformanceLog` instance.
*   **Process:**
    1.  Finds the specified `PerformanceLog`. Fails if not found.
    2.  Updates the `PerformanceLog` with:
        *   The provided `fitness_input_value`.
        *   The `outcome_metrics` (if provided).
        *   Sets `outcome_recorded_at` to the current time.
    3.  If the update fails (e.g., due to validations, though `PerformanceLog` currently has few), the command fails.
*   **Rollback:** If this command succeeds but a subsequent command in a chain fails, its `rollback` method will attempt to revert the `fitness_input_value`, `outcome_metrics`, and `outcome_recorded_at` fields of the `PerformanceLog` to their values before this command was executed.
