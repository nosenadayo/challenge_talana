# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { build(:task) }

  let(:skill) { create(:skill) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:estimated_hours) }

    it 'validates numericality of estimated_hours' do
      expect(task).to validate_numericality_of(:estimated_hours)
        .is_greater_than(0)
        .is_less_than_or_equal_to(24)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:task_skills).dependent(:destroy) }
    it { is_expected.to have_many(:skills).through(:task_skills) }
    it { is_expected.to have_many(:task_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:employees).through(:task_assignments) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:task)).to be_valid
    end
  end

  describe 'scopes' do
    let!(:overdue_task) { create(:task, :overdue, skills: [skill]) }
    let!(:future_task) { create(:task, :future, skills: [skill]) }
    let!(:assigned_task) { create(:task, :with_assignments, skills: [skill]) }
    let!(:unassigned_task) { create(:task, skills: [skill]) }

    describe '.unassigned' do
      it 'returns only unassigned tasks' do
        expect(described_class.unassigned).to include(unassigned_task, overdue_task, future_task)
        expect(described_class.unassigned).not_to include(assigned_task)
      end
    end

    describe '.assigned' do
      it 'returns only assigned tasks' do
        expect(described_class.assigned).to include(assigned_task)
        expect(described_class.assigned).not_to include(unassigned_task, overdue_task, future_task)
      end
    end

    describe '.pending_assignment' do
      it 'returns unassigned tasks with future due dates' do
        expect(described_class.pending_assignment).to include(future_task, unassigned_task)
        expect(described_class.pending_assignment).not_to include(overdue_task, assigned_task)
      end
    end

    describe '.overdue' do
      it 'returns unassigned tasks with past due dates' do
        expect(described_class.overdue).to include(overdue_task)
        expect(described_class.overdue).not_to include(future_task, unassigned_task, assigned_task)
      end
    end

    describe '.by_priority' do
      it 'orders tasks by due date and estimated hours' do
        ordered_tasks = described_class.by_priority
        expect(ordered_tasks.first).to eq(overdue_task)
        expect(ordered_tasks.last).to eq(future_task)
      end
    end
  end

  describe 'instance methods' do
    let(:task) { create(:task) }

    describe '#assigned?' do
      it 'returns true when task has assignments' do
        create(:task_assignment, task: task)
        expect(task).to be_assigned
      end

      it 'returns false when task has no assignments' do
        expect(task).not_to be_assigned
      end
    end

    describe '#priority_score' do
      let(:urgent_task) { create(:task, :urgent, skills: [skill]) }
      let(:future_task) { create(:task, :future, skills: [skill]) }

      it 'calculates higher score for urgent tasks' do
        expect(urgent_task.priority_score).to be > future_task.priority_score
      end

      it 'includes complexity in score calculation' do
        simple_task = create(:task, estimated_hours: 2, skills: [skill])
        complex_task = create(:task, estimated_hours: 8, skills: [skill])

        expect(complex_task.priority_score).to be > simple_task.priority_score
      end
    end
  end
end
