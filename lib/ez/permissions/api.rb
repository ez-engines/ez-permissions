# frozen_string_literal: true

require_relative 'api/roles'

module Ez
  module Permissions
    module API
      extend Ez::Permissions::API::Roles
    end
  end
end
