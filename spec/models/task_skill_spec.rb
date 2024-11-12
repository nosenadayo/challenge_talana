# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskSkill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:task_skill) }

    it { is_expected.to validate_uniqueness_of(:task_id).scoped_to(:skill_id) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:task_skill)).to be_valid
    end
  end
end
