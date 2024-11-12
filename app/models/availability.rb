# frozen_string_literal: true

class Availability < ApplicationRecord
  belongs_to :employee

  validates :date, presence: true
  validates :available_hours, presence: true,
                              numericality: { greater_than: 0, less_than_or_equal_to: 24 }
  validates :date, uniqueness: { scope: :employee_id }
end
