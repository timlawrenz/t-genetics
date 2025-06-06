# frozen_string_literal: true

class PerformanceLog < ApplicationRecord
  belongs_to :experiment
  belongs_to :organism

  validates :experiment, presence: true
  validates :organism, presence: true
  validates :suggested_at, presence: true
end
