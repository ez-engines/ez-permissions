# frozen_string_literal: true

require_relative 'authorize/model_permissions'
require_relative 'authorize/godmode_permissions'

module Ez
  module Permissions
    module API
      module Authorize
        def model_permissions(model)
          ModelPermissions.new(
            model.class.includes(assigned_roles: {role: :permissions}).find(model.id).assigned_roles.each_with_object({}) do |assigned_role, acum|
              scoped_key = [assigned_role.scoped_type, assigned_role.scoped_id].compact.join("_")
              assigned_role.role.permissions.each do |permission|
                acum["#{permission.action}_#{permission.resource}_#{scoped_key}".to_sym] = true
              end
            end
          )
        end

        def godmode_permissions
          GodmodPermissions.new({})
        end

        def authorize!(model, *actions, resource, scoped: nil, &block)
          authorize(model, *actions, resource, scoped: scoped, raise_exception: true, &block)
        end

        # TODO: Extract object
        # rubocop:disable all
        def authorize(model, *actions, resource, scoped: nil, raise_exception: false)
          return handle_no_permission_model_callback.call(self) if handle_no_permission_model_callback && !model

          if can?(model, *actions, resource, scoped: scoped)
            if block_given?
              return yield
            else
              return true
            end
          end

          if handle_not_authorized_callback
            handle_not_authorized_callback.call(self)
          elsif raise_exception
            raise NotAuthorizedError, not_authorized_msg(model, actions, resource, scoped)
          else
            false
          end
        end
        # rubocop:enable all

        def can?(model, *actions, resource, scoped: nil)
          permissions(model, *actions, resource, scoped: scoped).any?
        end

        private

        def permissions(model, *actions, resource, scoped: nil)
          # TODO: Refactor to 1 query with joins
          role_ids = model.assigned_roles.where(scoped: scoped).pluck(:role_id)
          permission_ids = Ez::Permissions::PermissionRole.where(role_id: role_ids).pluck(:permission_id)

          Ez::Permissions::Permission.where(
            id: permission_ids,
            resource: resource,
            action: actions.map(&:to_s)
          )
        end

        def not_authorized_msg(model, actions, resource, scoped = nil)
          msg = "#{model.class}##{model.id} is not authorized to [#{actions.join(', ')} -> #{resource}]"
          msg = "#{msg} for #{scoped.class}##{scoped.id}" if scoped

          msg
        end

        def handle_no_permission_model_callback
          Ez::Permissions.config.handle_no_permission_model
        end

        def handle_not_authorized_callback
          Ez::Permissions.config.handle_not_authorized
        end
      end
    end
  end
end
