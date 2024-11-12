# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Availability, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:available_hours) }
    it { is_expected.to validate_numericality_of(:available_hours).is_greater_than(0).is_less_than_or_equal_to(24) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:employee) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:availability)).to be_valid
    end
  end

  describe 'uniqueness' do
    let(:employee) { FactoryBot.create(:employee) }
    let(:date) { Date.current }

    it 'enforces unique employee and date combination' do
      FactoryBot.create(:availability, employee: employee, date: date)
      duplicate = FactoryBot.build(:availability, employee: employee, date: date)
      expect(duplicate).not_to be_valid
    end
  end
end
