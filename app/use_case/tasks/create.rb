# frozen_string_literal: true

module Tasks
  class Create
    include Interactor

    def call
      context.task = Task.new(context.task_params)
      context.task.save!

      # TODO: aqui lo ideal seria que se asigne el task a un usuario mediante un worker
      # ocupando el algoritmo de asignacion de tareas
      # el worker deberia estar en un archivo aparte llamado tasks/assignment_worker.rb
      # ocupando sidekiq para la ejecucion de este worker
    end
  end
end
