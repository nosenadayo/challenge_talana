# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:daily_hours) }
    it { is_expected.to validate_numericality_of(:daily_hours).is_greater_than(0).is_less_than_or_equal_to(24) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:employee_skills).dependent(:destroy) }
    it { is_expected.to have_many(:skills).through(:employee_skills) }
    it { is_expected.to have_many(:task_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:task_assignments) }
    it { is_expected.to have_many(:availabilities).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:employee)).to be_valid
    end
  end

  describe 'availability' do
    let(:employee) { FactoryBot.create(:employee) }
    let(:date) { Date.current }

    it 'is available when has availability for the date' do
      FactoryBot.create(:availability, employee: employee, date: date, available_hours: 8)
      expect(employee.availabilities.exists?(date: date)).to be true
    end

    it 'is not available when has no availability for the date' do
      expect(employee.availabilities.exists?(date: date)).to be false
    end
  end
end
