# frozen_string_literal: true

module Ez
  module Permissions
    class RolesController < Ez::Permissions::ApplicationController
      if Ez::Permissions.config.ui_roles_controller_context
        instance_exec(&Ez::Permissions.config.ui_roles_controller_context)
      end

      def index
        view 'roles/index', Ez::Permissions::Role.all
      end
    end
  end
end
