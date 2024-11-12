# frozen_string_literal: true

class AvailabilitySerializer
  include JSONAPI::Serializer

  attributes :date, :available_hours

  belongs_to :employee, serializer: EmployeeSerializer

  attribute :day_of_week do |object|
    object.date.strftime('%A')
  end
end
