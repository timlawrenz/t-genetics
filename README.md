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
*   **Commands (`app/commands`):** Encapsulate business logic for evolutionary operations (e.g., `Generations::Fitness`, `Organisms::Procreate`, `Organisms::Crossover`). These likely use the `gl_command` gem.
*   **Controllers (`app/controllers`):** Handle web requests, primarily for managing `Chromosome`s and `Allele`s.
*   **Views (`app/views`):** Provide the user interface for interacting with the application.
*   **Database Migrations (`db/migrate`):** Define the database schema.

## Further Development

(This section could outline potential future enhancements or areas of focus.)
