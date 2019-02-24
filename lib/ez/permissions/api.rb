# frozen_string_literal: true

require_relative 'api/roles'
require_relative 'api/permissions'
require_relative 'api/models'
require_relative 'api/authorize'

module Ez
  module Permissions
    module API
      extend Ez::Permissions::API::Roles
      extend Ez::Permissions::API::Permissions
      extend Ez::Permissions::API::Models
      extend Ez::Permissions::API::Authorize
    end
  end
end
