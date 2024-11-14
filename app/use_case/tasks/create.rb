# frozen_string_literal: true

module Tasks
  class Create
    include Interactor

    def call
      task = Task.new(context.params)

      if task.save
        context.task = task
      else
        context.fail!(error_messages: task.errors.full_messages)
      end
    end
  end
end
