# frozen_string_literal: true

require 'ez/permissions/engine'
require 'ez/permissions/dsl'
require 'ez/permissions/api'
require 'ez/configurator'

module Ez
  module Permissions
    include Ez::Configurator

    configure do |config|
      config.permissions_table_name       = 'ez_permissions_permissions'
      config.roles_table_name             = 'ez_permissions_roles'
      config.models_roles_table_name      = 'ez_permissions_model_roles'
      config.permissions_roles_table_name = 'ez_permissions_permissions_roles'
    end

    NotAuthorizedError = Class.new(StandardError)
  end
end
