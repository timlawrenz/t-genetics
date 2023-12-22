# frozen_string_literal: true

class Generation < ApplicationRecord
  belongs_to :chromosome
  has_many :organisms, dependent: :destroy

  scope :latest, -> { order(iteration: :desc).first }
end
