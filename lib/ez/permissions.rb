# frozen_string_literal: true

require 'ez/permissions/engine'
require 'ez/permissions/dsl'
require 'ez/permissions/api'
require 'ez/configurator'

module Ez
  module Permissions
    include Ez::Configurator

    extend Ez::Permissions::API

    configure do |c|
      c.permissions_table_name = 'ez_permissions_permissions'
      c.roles_table_name = 'ez_permissions_roles'
    end
  end
end
