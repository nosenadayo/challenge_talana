# frozen_string_literal: true

module Api
  module V1
    class SkillsController < ApplicationController
      def index
        @skills = Skill.all
        render json: @skills.select(:id, :name)
      end
    end
  end
end
