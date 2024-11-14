# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
      rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_response

      private

      def not_found_response(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def invalid_record_response(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
