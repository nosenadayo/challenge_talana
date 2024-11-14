# frozen_string_literal: true

module Api
  module V1
    class EmployeesController < BaseController
      before_action :validate_date_param, only: [:available_on_date]

      def index
        employees = Employee.includes(:skills, :availabilities)
        render json: EmployeeSerializer.new(employees, index_options).serializable_hash
      end

      def show
        employee = Employee.find(params[:id])
        render json: EmployeeSerializer.new(employee, show_options).serializable_hash
      end

      def availability
        employee = Employee.find(params[:id])
        availabilities = employee.availabilities.where(date: date_range)
        render json: AvailabilitySerializer.new(availabilities).serializable_hash
      end

      def available_on_date
        date = Date.parse(params[:date])
        employees = Employee.joins(:availabilities)
                            .where(availabilities: { date: date })
                            .includes(:skills)

        render json: EmployeeSerializer.new(employees, index_options).serializable_hash
      end

      private

      def date_range # rubocop:disable Metrics/AbcSize
        start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today
        end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : 30.days.from_now.to_date
        start_date..end_date
      end

      def validate_date_param
        if params[:date].blank?
          render json: { error: 'Date parameter is required' }, status: :bad_request
          return
        end

        Date.parse(params[:date])
      rescue ArgumentError
        render json: { error: 'Invalid date format' }, status: :bad_request
      end

      def index_options
        { include: [:skills] }
      end

      def show_options
        { include: %i[skills availabilities] }
      end
    end
  end
end
