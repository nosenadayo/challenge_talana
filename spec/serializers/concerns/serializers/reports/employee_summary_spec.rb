# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serializers::Reports::EmployeeSummary do
  let(:date) { Time.zone.today }
  let(:employee) { create(:employee) }
  let(:task) { create(:task) }
  let!(:assignment) { create(:task_assignment, employee: employee, task: task, assigned_date: date) }

  describe '.generate_employees_summary' do
    subject(:summary) { TaskAssignmentReportSerializer.generate_employees_summary(date) }

    it 'includes employee details' do
      expect(summary.first).to include(
        id: employee.id,
        name: employee.name
      )
    end

    it 'calculates hours correctly' do
      expect(summary.first[:total_hours]).to eq(task.estimated_hours)
      expect(summary.first[:available_hours]).to eq(8 - task.estimated_hours)
    end
  end
end
