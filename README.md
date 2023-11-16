# t-genetics

## Allele

A chromosome has many Alleles that define its characteristics.

```ruby
class Bird < ActiveRecord::Base
  include T::Genetics

  allele :number_of_legs, mutate: :random_number_of_legs, crossover: T::Genetics::Crossover::RandomSwitch
  allele :number_of_wings, mutate: :random_number_of_wings, crossover: T::Genetics::Crossover::Average

  private

  def random_number_of_legs
    [0..10].sample
  end

  def random_number_of_wings
    [1..5].sample
  end
end
