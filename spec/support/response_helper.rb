# frozen_string_literal: true

module Response
  module JsonHelper
    def json_response
      @json_response ||= JSON.parse(response.body)
    end
  end
end
