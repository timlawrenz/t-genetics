chromosome = Chromosome.create(name: 'Tip Recommendations')

['button1', 'botton2', 'button3'].each do |name|
  chromosome.alleles.create(name:, inheritable: Alleles::Float.create(minimum: 1, maximum: 50))
end

generation = chromosome.generations.create(iteration: 1)
Organism.create(generation:)
