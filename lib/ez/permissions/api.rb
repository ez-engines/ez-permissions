# frozen_string_literal: true

require_relative 'api/roles'
require_relative 'api/permissions'
require_relative 'api/models'

module Ez
  module Permissions
    module API
      extend Ez::Permissions::API::Roles
      extend Ez::Permissions::API::Permissions
      extend Ez::Permissions::API::Models
    end
  end
end
