# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:employee_skills).dependent(:destroy) }
    it { is_expected.to have_many(:employees).through(:employee_skills) }
    it { is_expected.to have_many(:task_skills).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:task_skills) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:skill)).to be_valid
    end
  end

  describe 'database constraints' do
    it 'enforces unique names at the database level' do
      skill = FactoryBot.create(:skill)
      duplicate_skill = FactoryBot.build(:skill, name: skill.name)
      expect { duplicate_skill.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
