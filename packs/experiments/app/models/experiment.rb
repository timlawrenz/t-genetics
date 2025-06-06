class Experiment < ApplicationRecord
  belongs_to :chromosome
  belongs_to :current_generation, class_name: 'Generation', foreign_key: 'current_generation_id', optional: true

  validates :chromosome_id, presence: true
  validates :external_entity_id, presence: true
  validates :external_entity_type, presence: true
  validates :status, presence: true
end
