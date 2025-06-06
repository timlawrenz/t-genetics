class Experiment < ApplicationRecord
  include AASM

  belongs_to :chromosome
  belongs_to :current_generation, class_name: 'Generation', foreign_key: 'current_generation_id', optional: true

  validates :chromosome_id, presence: true
  validates :external_entity_id, presence: true
  validates :external_entity_type, presence: true
  # AASM handles status validation based on defined states

  aasm :status, column: :status do # Explicitly mention column name, though it's default
    state :pending, initial: true
    state :running
    state :completed
    state :failed

    event :start do
      transitions from: :pending, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end

    event :fail do
      transitions from: :running, to: :failed
    end
  end
end
