# frozen_string_literal: true

require_relative 'api/roles'
require_relative 'api/permissions'

module Ez
  module Permissions
    module API
      extend Ez::Permissions::API::Roles
      extend Ez::Permissions::API::Permissions
    end
  end
end
