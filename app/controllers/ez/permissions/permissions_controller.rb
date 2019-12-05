# frozen_string_literal: true

module Ez
  module Permissions
    class PermissionsController < Ez::Permissions::ApplicationController
      if Ez::Permissions.config.ui_permissions_controller_context
        instance_exec(&Ez::Permissions.config.ui_permissions_controller_context)
      end

      def index
        view 'roles/permissions', role, permissions: []
      end

      def create
        role.permission_ids = params.to_unsafe_hash['permissions'] || []

        redirect_to(
          Ez::Permissions.config.ui_base_routes,
          notice: t('permissions.messages.updated', scope: ApplicationCell::I18N_SCOPE)
        )
      end

      private

      def role
        @role ||= Ez::Permissions::Role.find(params[:role_id])
      end
    end
  end
end
