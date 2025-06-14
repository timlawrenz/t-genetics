# frozen_string_literal: true

module ComfyGenetics
  class Chromosome < ComfyGenetics::ApplicationRecord
    validates :name, presence: true
    has_many :alleles, dependent: :destroy # TODO: ComfyGenetics::Allele
    has_many :generations, dependent: :destroy # TODO: ComfyGenetics::Generation
    has_many :organisms, through: :generations # TODO: ComfyGenetics::Organism

    after_initialize do
      alleles.each do |allele| # TODO: ComfyGenetics::Allele
        self.class.send(:define_method, allele.name) { allele }
      end
    end

    def to_s
      "#<Chromosome id:#{id} name:#{name} alleles:[#{alleles.map(&:to_s).sort.join(', ')}]>" # TODO: ComfyGenetics::Allele
    end
  end
end
