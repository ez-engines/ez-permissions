# frozen_string_literal: true

module Ez
  module Permissions
    module Roles
      class IndexCell < ApplicationCell
        def can_edit?
          available_actions.include?(:edit)
        end

        def can_remove?
          available_actions.include?(:remove)
        end

        def role_permissions_link(role)
          link_to t('roles.actions.permissions'),
                  path_for("roles/#{role.id}/permissions"),
                  class: css_for('roles-table-permissions-link')
        end

        private

        def available_actions
          @available_actions ||= Ez::Permissions.config.ui_roles_actions || []
        end
      end
    end
  end
end
