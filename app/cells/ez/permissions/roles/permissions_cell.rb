# frozen_string_literal: true

module Ez
  module Permissions
    module Roles
      class PermissionsCell < ApplicationCell
        COMMON_ACTIONS_ORDER = Ez::Permissions.config.ui_actions_ordering || %w[create read update delete].freeze

        form

        def actions_names
          @actions_names ||= permissions_actions
                             .map(&:action)
                             .uniq
                             .sort_by { |a| (COMMON_ACTIONS_ORDER.index(a).to_s || a) }
        end

        def resources_names
          @resources_names ||= permissions_actions.map(&:resource).uniq.sort
        end

        def permissions_actions
          @permissions_actions ||= Ez::Permissions::Permission.all.to_a
        end

        def role_permissions
          @role_permissions ||= model.permissions.to_a
        end

        def role_permission_ids
          @role_permission_ids ||= role_permissions.map(&:id)
        end

        def permission_id(resource_name, action_name)
          permissions_actions.find { |p| p.resource == resource_name && p.action == action_name }&.id
        end

        def granted_permission?(permission_id)
          role_permission_ids.include?(permission_id)
        end

        def permission_checkbox(resource_name, action_name)
          permission_id = permission_id(resource_name, action_name)

          return unless permission_id

          check_box_tag 'permissions[]',
                        permission_id,
                        granted_permission?(permission_id),
                        id: "permission-checkbox-#{resource_name}-#{action_name}"
        end

        def all_granted?(resource_name = nil)
          if resource_name
            role_permissions.select { |p| p.resource == resource_name }.size ==
              permissions_actions.select { |p| p.resource == resource_name }.size
          else
            role_permissions.size == permissions_actions.size
          end
        end

        def form_url
          "#{Ez::Permissions.config.ui_base_routes}/roles/#{model.id}/permissions"
        end
      end
    end
  end
end
