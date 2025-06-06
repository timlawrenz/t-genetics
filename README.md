# TGenetics: Evolutionary Computation Platform

This application provides a framework for exploring and utilizing genetic algorithms and evolutionary computation.

## Core Functionality

The system is designed to:

*   **Define Genetic Structures:** Users can define `Chromosome`s, which are composed of `Allele`s. Alleles can be of various types, including:
    *   `Float` (representing a range of floating-point numbers)
    *   `Integer` (representing a range of integers)
    *   `Boolean` (representing true/false values)
    *   `Option` (representing a selection from a predefined list of choices)
*   **Manage Populations:** The application supports the creation and management of `Generation`s, which are collections of `Organism`s. Each organism possesses a set of `Value`s corresponding to the alleles in its chromosome.
*   **Simulate Evolution:** Key evolutionary operations are implemented as commands, allowing for:
    *   **Fitness Evaluation:** Calculating the `Fitness` of organisms within a generation.
    *   **Selection:** Picking organisms for reproduction based on fitness or other criteria (`Generations::Pick`).
    *   **Reproduction:**
        *   `Cloning`: Creating identical copies of organisms.
        *   `Crossover`: Combining genetic material from parent organisms to create offspring.
        *   `Procreation`: A higher-level command that orchestrates the creation of new organisms from parents, often involving crossover and mutation.
    *   **Mutation:** Introducing random changes to an organism's genetic material (`Organism#mutate!`).
*   **Data Output:** The `WriteTrainingFiles` command suggests functionality to export genetic data, potentially for use in training external machine learning models or other analytical processes.
*   **Web Interface:** A web interface (built with Ruby on Rails) allows for the management and inspection of `Chromosome`s and `Allele`s.

## Getting Started

(This section would typically include instructions on setting up the development environment, such as Ruby version, system dependencies, database setup, etc.)

*   Ruby version: (Specify from `.ruby-version`)
*   System dependencies: (List any)
*   Configuration: (Details on `config/database.yml`, etc.)
*   Database creation: `rails db:create`
*   Database initialization: `rails db:schema:load` (or `rails db:setup` which includes seeds)
*   How to run the test suite: `bundle exec rspec`

## Key Components

*   **Models (`app/models`):** Define the core data structures like `Chromosome`, `Allele`, `Generation`, `Organism`, and `Value`. Different allele types (`Alleles::Float`, `Alleles::Integer`, etc.) and their corresponding value types (`Values::Float`, `Values::Integer`, etc.) are implemented using single table inheritance or polymorphic associations.

## Genetic Algorithm Process

The application implements a genetic algorithm with the following key steps:

1.  **Initialization (`Organisms::Create`)**:
    *   When an `Organism` is created, it is associated with a `Generation` and its `Chromosome`.
    *   For each `Allele` in the `Chromosome`, a corresponding `Value` instance is created.
    *   The `Value.new_from(allele)` method initializes the specific `valuable` type (e.g., `Values::Float`, `Values::Integer`), which then assigns an initial `data` value, typically randomly within the allele's defined constraints (e.g., min/max for numbers, a random choice for options).

2.  **Fitness Evaluation (`Generations::Fitness`, `Organism#fitness` attribute)**:
    *   Each `Organism` has a `fitness` attribute that stores its evaluated fitness score.
    *   The `Generations::Fitness` command calculates aggregate fitness metrics, such as total and average fitness, for all organisms within a `Generation`.
    *   Fitness scores are typically assigned to organisms externally and then updated (e.g., via `organism.update(fitness: ...)`).

3.  **Selection (`Generations::Pick`)**:
    *   The `Generations::Pick` command selects an organism from a parent `Generation` to act as a parent.
    *   It uses a fitness proportionate selection method (roulette wheel selection):
        *   The total fitness of the parent generation is calculated.
        *   A random selection point is chosen based on this total fitness.
        *   Organisms are iterated, and their fitness values are cumulatively summed. The organism whose cumulative fitness contribution causes the sum to exceed the random selection point is chosen.

4.  **Crossover (`Organisms::Procreate` calling `Organisms::Crossover`)**:
    *   The `Organisms::Procreate` command orchestrates reproduction:
        1.  It takes two selected `parents`.
        2.  It creates `children` by initially cloning each parent using `parent.dolly_clone`. These children start as exact copies.
        3.  It then invokes `Organisms::Crossover.call!(organisms: context.children)` to perform genetic crossover on these cloned children.
    *   The `Organisms::Crossover` command:
        1.  Iterates through the alleles of the first child's chromosome.
        2.  For each allele, it gathers the corresponding `Value` instances from all children involved in the crossover.
        3.  It calls the `allele.crossover_algorithm` (e.g., `Organisms::Crossovers::Average` or `Organisms::Crossovers::Random`) with these values.
        4.  The specific crossover algorithm (e.g., `Average`) then modifies the `data` of these allele values directly on the children. For instance, `Organisms::Crossovers::Average` would set the allele's value on both children to be the average of their (initially cloned) parental values for that allele.

5.  **Mutation (`Organisms::Procreate` calling `Organism#mutate!`)**:
    *   Following crossover, `Organisms::Procreate` calls the `mutate!` method on each child.
    *   `Organism#mutate!` iterates through all `Value` instances of the organism.
    *   Each `Value` has a probability (defined by `MUTATION_RATE`) of being mutated.
    *   If selected for mutation, `value.mutate!` is called, which sets the `data` of the underlying `valuable` object to a new random value, appropriate for the allele's type and constraints.

6.  **Replacement/Next Generation (`Generations::New`)**:
    *   The `Generations::New` command is responsible for creating a new `offspring_generation`.
    *   It repeatedly performs the selection and procreation (cloning, crossover, mutation) sequence:
        *   Picks parent organisms from the `parent_generation`.
        *   Calls `Organisms::Procreate` to generate children from these parents.
        *   Assigns these newly created children to the `offspring_generation`.
    *   This process continues until the `offspring_generation` reaches its target `organism_count`. This implements a generational replacement strategy.
*   **Commands (`app/commands`):** Encapsulate business logic for evolutionary operations (e.g., `Generations::Fitness`, `Organisms::Procreate`, `Organisms::Crossover`). These likely use the `gl_command` gem.
*   **Controllers (`app/controllers`):** Handle web requests, primarily for managing `Chromosome`s and `Allele`s.
*   **Views (`app/views`):** Provide the user interface for interacting with the application.
*   **Database Migrations (`db/migrate`):** Define the database schema.

## Further Development

(This section could outline potential future enhancements or areas of focus.)
