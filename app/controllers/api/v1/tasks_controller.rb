# frozen_string_literal: true

module Api
  module V1
    class TasksController < BaseController
      skip_before_action :verify_authenticity_token

      def index
        tasks = Task.includes(:skills)
        render json: TaskSerializer.new(tasks).serializable_hash
      end

      def show
        task = Task.find(params[:id])
        render json: TaskSerializer.new(task).serializable_hash
      end

      def create
        result = Tasks::Create.call(params: task_params)

        if result.success?
          render json: TaskSerializer.new(result.task).serializable_hash,
                 status: :created
        else
          render json: { errors: result.error_messages },
                 status: :unprocessable_entity
        end
      end

      def pending
        tasks = Task.pending_assignment
        render json: TaskSerializer.new(tasks).serializable_hash
      end

      def overdue
        tasks = Task.overdue
        render json: TaskSerializer.new(tasks).serializable_hash
      end

      private

      def task_params
        params.require(:task).permit(
          Task.allowed_attributes
        )
      end
    end
  end
end
