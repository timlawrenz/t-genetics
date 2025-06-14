# frozen_string_literal: true

module ComfyGenetics
  class Allele < ComfyGenetics::ApplicationRecord
    validates :name, presence: true

    delegated_type :inheritable,
                   types: ['Alleles::Float',
                           'Alleles::Boolean',
                           'Alleles::Integer',
                           'Alleles::Option'] # TODO: These might need to be ComfyGenetics::Alleles::...

    scope :by_name, ->(name) { find_by(name:) }

    belongs_to :chromosome # TODO: Might need to be ComfyGenetics::Chromosome
    has_many :values, dependent: :destroy # TODO: Might need to be ComfyGenetics::Value

    def self.new_with_float(name:, minimum:, maximum:)
      new(name:, inheritable: Alleles::Float.create(minimum:, maximum:)) # TODO: ComfyGenetics::Alleles::Float
    end

    def self.new_with_integer(name:, minimum:, maximum:)
      new(name:, inheritable: Alleles::Integer.create(minimum:, maximum:)) # TODO: ComfyGenetics::Alleles::Integer
    end

    def self.new_with_boolean(name:)
      new(name:, inheritable: Alleles::Boolean.create) # TODO: ComfyGenetics::Alleles::Boolean
    end

    def self.new_with_option(name:, choices:)
      new(name:, inheritable: Alleles::Option.create(choices:)) # TODO: ComfyGenetics::Alleles::Option
    end

    def crossover_algorithm
      Organisms::Crossovers::Average # TODO: ComfyGenetics::Organisms::Crossovers::Average
    end

    def type
      inheritable.class.to_s.split('::').last # This might be okay if inheritable types are already namespaced
    end

    def to_s
      "#{name}: [#{inheritable}]"
    end
  end
end
