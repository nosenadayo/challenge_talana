# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:estimated_hours) }
    it { is_expected.to validate_numericality_of(:estimated_hours).is_greater_than(0) }
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
    let!(:past_task) { FactoryBot.create(:task, due_date: 1.day.ago) }
    let!(:future_task) { FactoryBot.create(:task, due_date: 1.day.from_now) }

    it 'includes only future tasks' do
      future_tasks = described_class.where('due_date > ?', Date.current)
      expect(future_tasks).to include(future_task)
    end

    it 'excludes past tasks' do
      future_tasks = described_class.where('due_date > ?', Date.current)
      expect(future_tasks).not_to include(past_task)
    end
  end
end
