# frozen_string_literal: true

module Tasks
  class CreateAndSchedule
    include Interactor::Organizer

    organize Create, ScheduleAssignment
  end
end
