# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskAssignment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:employee) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:task_assignment) }

    it { is_expected.to validate_uniqueness_of(:task_id).scoped_to(:assigned_date) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:task_assignment)).to be_valid
    end
  end
end
