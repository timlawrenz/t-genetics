# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'TGenetics API', openapi_spec: 'v1/swagger.yaml', type: :request do
  path '/chromosomes' do
    get 'List chromosomes' do
      tags 'Chromosomes'
      produces 'application/json'

      response '200', 'chromosomes listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Chromosome' }

        before { Chromosome.create!(name: 'experiment 1') }

        run_test!
      end
    end

    post 'Create chromosome' do
      tags 'Chromosomes'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :chromosome, in: :body, schema: {
        type: :object,
        required: [:chromosome],
        properties: {
          chromosome: {
            type: :object,
            required: [:name],
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '201', 'chromosome created' do
        schema '$ref' => '#/components/schemas/Chromosome'
        let(:chromosome) { { chromosome: { name: 'experiment 1' } } }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'
        let(:chromosome) { { chromosome: { name: '' } } }

        run_test!
      end
    end
  end

  path '/chromosomes/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show chromosome' do
      tags 'Chromosomes'
      produces 'application/json'

      response '200', 'chromosome found' do
        schema '$ref' => '#/components/schemas/Chromosome'
        let(:id) { Chromosome.create!(name: 'experiment 1').id }

        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }

        run_test!
      end
    end

    patch 'Update chromosome' do
      tags 'Chromosomes'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :chromosome, in: :body, schema: {
        type: :object,
        required: [:chromosome],
        properties: {
          chromosome: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'chromosome updated' do
        schema '$ref' => '#/components/schemas/Chromosome'
        let(:existing) { Chromosome.create!(name: 'experiment 1') }
        let(:id) { existing.id }
        let(:chromosome) { { chromosome: { name: 'experiment 2' } } }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'
        let(:existing) { Chromosome.create!(name: 'experiment 1') }
        let(:id) { existing.id }
        let(:chromosome) { { chromosome: { name: '' } } }

        run_test!
      end
    end

    delete 'Delete chromosome' do
      tags 'Chromosomes'
      produces 'application/json'

      response '204', 'chromosome deleted' do
        let(:id) { Chromosome.create!(name: 'experiment 1').id }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/alleles' do
    parameter name: :chromosome_id, in: :path, type: :integer

    get 'List alleles' do
      tags 'Alleles'
      produces 'application/json'

      response '200', 'alleles listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Allele' }

        let(:chromosome_id) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome.id
        end

        run_test!
      end
    end

    post 'Create allele' do
      tags 'Alleles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :allele, in: :body, schema: {
        type: :object,
        required: [:allele],
        properties: {
          allele: {
            type: :object,
            required: %i[name type],
            properties: {
              name: { type: :string },
              type: { type: :string, description: 'One of Integer|Float|Boolean|Option' },
              minimum: { type: :number, nullable: true },
              maximum: { type: :number, nullable: true },
              choices: { type: :array, items: { type: :string }, nullable: true }
            }
          }
        }
      }

      response '201', 'integer allele created' do
        schema '$ref' => '#/components/schemas/Allele'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:chromosome_id) { chromosome.id }
        let(:allele) { { allele: { name: 'legs', type: 'Integer', minimum: 1, maximum: 50 } } }

        run_test!
      end

      response '201', 'option allele created' do
        schema '$ref' => '#/components/schemas/Allele'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:chromosome_id) { chromosome.id }
        let(:allele) { { allele: { name: 'color', type: 'Option', choices: %w[green blue] } } }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:chromosome_id) { chromosome.id }
        let(:allele) { { allele: { name: 'legs', type: 'Integer' } } }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/alleles/{id}' do
    parameter name: :chromosome_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Show allele' do
      tags 'Alleles'
      produces 'application/json'

      response '200', 'allele found' do
        schema '$ref' => '#/components/schemas/Allele'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:created) { (chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)).last }
        let(:chromosome_id) { chromosome.id }
        let(:id) { created.id }

        run_test!
      end

      response '404', 'not found' do
        let(:chromosome_id) { Chromosome.create!(name: 'experiment 1').id }
        let(:id) { 0 }

        run_test!
      end
    end

    patch 'Update allele' do
      tags 'Alleles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :allele, in: :body, schema: {
        type: :object,
        required: [:allele],
        properties: {
          allele: {
            type: :object,
            properties: {
              name: { type: :string },
              type: { type: :string },
              minimum: { type: :number, nullable: true },
              maximum: { type: :number, nullable: true },
              choices: { type: :array, items: { type: :string }, nullable: true }
            }
          }
        }
      }

      response '200', 'allele updated' do
        schema '$ref' => '#/components/schemas/Allele'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:existing) { (chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)).last }
        let(:chromosome_id) { chromosome.id }
        let(:id) { existing.id }
        let(:allele) { { allele: { minimum: 2, maximum: 60 } } }

        run_test!
      end

      response '422', 'type cannot be changed' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:existing) { (chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)).last }
        let(:chromosome_id) { chromosome.id }
        let(:id) { existing.id }
        let(:allele) { { allele: { type: 'Float' } } }

        run_test!
      end
    end

    delete 'Delete allele' do
      tags 'Alleles'
      produces 'application/json'

      response '204', 'allele deleted' do
        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:existing) { (chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)).last }
        let(:chromosome_id) { chromosome.id }
        let(:id) { existing.id }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/generations' do
    parameter name: :chromosome_id, in: :path, type: :integer

    get 'List generations' do
      tags 'Generations'
      produces 'application/json'

      response '200', 'generations listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Generation' }

        let(:chromosome_id) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.generations.create!(iteration: 1)
          chromosome.id
        end

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/generations/{id}' do
    parameter name: :chromosome_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Show generation' do
      tags 'Generations'
      produces 'application/json'

      response '200', 'generation found' do
        schema '$ref' => '#/components/schemas/Generation'

        let(:chromosome) { Chromosome.create!(name: 'experiment 1') }
        let(:chromosome_id) { chromosome.id }
        let(:id) { chromosome.generations.create!(iteration: 1).id }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/generations/{id}/procreate' do
    parameter name: :chromosome_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    post 'Procreate a new generation' do
      tags 'Generations'
      produces 'application/json'

      response '201', 'offspring generation created' do
        schema '$ref' => '#/components/schemas/Generation'

        let(:chromosome) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome
        end

        let(:parent_generation) do
          generation = chromosome.generations.create!(iteration: 1)
          o1 = Organisms::Create.call(generation:).organism
          o2 = Organisms::Create.call(generation:).organism
          o1.update!(fitness: 100)
          o2.update!(fitness: 50)
          generation
        end

        let(:chromosome_id) { chromosome.id }
        let(:id) { parent_generation.id }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/generations/{generation_id}/organisms' do
    parameter name: :chromosome_id, in: :path, type: :integer
    parameter name: :generation_id, in: :path, type: :integer

    get 'List organisms' do
      tags 'Organisms'
      produces 'application/json'

      response '200', 'organisms listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Organism' }

        let(:chromosome) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome
        end
        let(:generation) do
          generation = chromosome.generations.create!(iteration: 1)
          Organisms::Create.call(generation:)
          generation
        end

        let(:chromosome_id) { chromosome.id }
        let(:generation_id) { generation.id }

        run_test!
      end
    end
  end

  path '/chromosomes/{chromosome_id}/generations/{generation_id}/organisms/{id}' do
    parameter name: :chromosome_id, in: :path, type: :integer
    parameter name: :generation_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Show organism' do
      tags 'Organisms'
      produces 'application/json'

      response '200', 'organism found' do
        schema '$ref' => '#/components/schemas/Organism'

        let(:chromosome) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome
        end
        let(:generation) do
          generation = chromosome.generations.create!(iteration: 1)
          Organisms::Create.call(generation:)
          generation
        end
        let(:organism) { generation.organisms.first }

        let(:chromosome_id) { chromosome.id }
        let(:generation_id) { generation.id }
        let(:id) { organism.id }

        run_test!
      end
    end

    patch 'Update organism fitness' do
      tags 'Organisms'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :organism, in: :body, schema: {
        type: :object,
        required: [:organism],
        properties: {
          organism: {
            type: :object,
            properties: {
              fitness: { type: :number }
            }
          }
        }
      }

      response '200', 'organism updated' do
        schema '$ref' => '#/components/schemas/Organism'

        let(:chromosome) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome
        end
        let(:generation) do
          generation = chromosome.generations.create!(iteration: 1)
          Organisms::Create.call(generation:)
          generation
        end
        let(:organism_record) { generation.organisms.first }

        let(:chromosome_id) { chromosome.id }
        let(:generation_id) { generation.id }
        let(:id) { organism_record.id }
        let(:organism) { { organism: { fitness: 100 } } }

        run_test!
      end

      response '400', 'missing organism param' do
        let(:chromosome) do
          chromosome = Chromosome.create!(name: 'experiment 1')
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome
        end
        let(:generation) do
          generation = chromosome.generations.create!(iteration: 1)
          Organisms::Create.call(generation:)
          generation
        end
        let(:organism_record) { generation.organisms.first }

        let(:chromosome_id) { chromosome.id }
        let(:generation_id) { generation.id }
        let(:id) { organism_record.id }
        let(:organism) { {} }

        run_test!
      end
    end
  end
end
