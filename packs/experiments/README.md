# Experiments Pack

This pack manages `Experiment` records, which are used to track and configure runs of genetic algorithms or evolutionary processes.

## Core Model: `Experiment`

The `Experiment` model is central to this pack. It encapsulates the setup and state of a specific evolutionary run.

### Key Attributes:

*   `chromosome_id`: A foreign key linking the experiment to a `Chromosome`. This defines the genetic structure being evolved.
*   `external_entity_id` & `external_entity_type`: A polymorphic association allowing an experiment to be linked to an external record in the system (e.g., a specific project, a user request, etc.). This provides context for why the experiment is being run.
*   `status`: A string field to track the current state of the experiment (e.g., "pending", "running", "completed", "failed").
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
