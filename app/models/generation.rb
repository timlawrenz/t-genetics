class Generation < ApplicationRecord
  belongs_to :chromosome
  has_many :organisms, dependent: :destroy
end
