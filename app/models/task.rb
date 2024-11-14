# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :task_skills, dependent: :destroy
  has_many :skills, through: :task_skills
  has_many :task_assignments, dependent: :destroy
  has_many :employees, through: :task_assignments

  validates :title, presence: true
  validates :due_date, presence: true
  validates :estimated_hours, presence: true,
                              numericality: {
                                greater_than: 0,
                                less_than_or_equal_to: 24
                              }
  validate :due_date_cannot_be_in_past, on: :create
  validate :must_have_skills

  scope :unassigned, lambda {
    where.missing(:task_assignments)
  }

  scope :assigned, lambda {
    joins(:task_assignments)
      .distinct
  }

  scope :pending_assignment, lambda {
    unassigned
      .where(due_date: Time.zone.today..)
      .order(due_date: :asc, estimated_hours: :desc)
  }

  scope :overdue, lambda {
    unassigned
      .where(due_date: ...Time.zone.today)
  }

  scope :by_priority, lambda {
    order(due_date: :asc, estimated_hours: :desc)
  }

  def self.allowed_attributes
    [
      :title,
      :due_date,
      :estimated_hours,
      { skill_ids: [] }
    ]
  end

  def assigned?
    task_assignments.exists?
  end

  def overdue?
    due_date < Time.zone.today && !assigned?
  end

  def days_until_due
    (due_date - Time.zone.today).to_i
  end

  def priority_score
    days_until_due = (due_date - Time.zone.today).to_i
    complexity_factor = estimated_hours / 24.0 # Normalizamos a un día completo

    base_score = 100
    urgency_score = [50 - (days_until_due * 2), 0].max # Aumentamos el factor de urgencia
    complexity_score = complexity_factor * 30 # Aumentamos el impacto de la complejidad

    base_score + urgency_score + complexity_score
  end

  private

  def due_date_cannot_be_in_past
    return unless due_date.present? && due_date < Time.zone.today

    errors.add(:due_date, 'no puede estar en el pasado')
  end

  def must_have_skills
    return unless skills.empty?

    errors.add(:skills, 'debe tener al menos una habilidad requerida')
  end
end
