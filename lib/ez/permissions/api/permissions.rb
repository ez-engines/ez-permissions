# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Permissions
        PermissionNotFound = Class.new(StandardError)

        def get_permission!(action, resource)
          Ez::Permissions::Permission.find_by!(resource: resource, action: action)
        rescue ActiveRecord::RecordNotFound
          raise PermissionNotFound, "Permission [#{action} -> #{resource}] not found"
        end

        def grant_permission(role_name, action, resource)
          role = Ez::Permissions::API.get_role!(role_name)

          if action == :all
            grant_all_permissions(role, resource)
          else
            permission = get_permission!(action, resource)
            grant_single_permission(role, permission)
          end
        end

        def revoke_permission(role_name, action, resource)
          role = Ez::Permissions::API.get_role!(role_name)
          permission = get_permission!(action, resource)

          Ez::Permissions::PermissionRole.find_by(
            role: role,
            permission: permission
          )&.delete
        end

        private

        def grant_single_permission(role, permission)
          Ez::Permissions::PermissionRole.find_or_create_by!(
            role: role,
            permission: permission
          )
        end

        def grant_all_permissions(role, resource)
          Ez::Permissions::DSL.resource(resource).actions.each do |action|
            permission = get_permission!(action, resource)
            grant_single_permission(role, permission)
          end
        end
      end
    end
  end
end
