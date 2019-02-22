# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Permissions
        def get_permission!(action, resource)
          Ez::Permissions::Permission.find_by!(resource: resource, action: action)
        end

        def grant_permission(role_name, action, resource)
          role = Ez::Permissions::API.get_role!(role_name)
          permission = get_permission!(action, resource)

          Ez::Permissions::PermissionRole.find_or_create_by!(
            role:       role,
            permission: permission
          )
        end

        def revoke_permission(role_name, action, resource)
          role = Ez::Permissions::API.get_role!(role_name)
          permission = get_permission!(action, resource)

          Ez::Permissions::PermissionRole.find_by(
            role:       role,
            permission: permission
          )&.delete
        end
      end
    end
  end
end
