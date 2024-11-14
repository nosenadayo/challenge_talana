# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeeSkill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:employee_skill) }

    it { is_expected.to validate_uniqueness_of(:employee_id).scoped_to(:skill_id) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:employee_skill)).to be_valid
    end
  end
end
