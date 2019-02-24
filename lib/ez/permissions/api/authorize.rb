# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Authorize
        NotAuthorized = Class.new(StandardError)

        def authorize!(model, *actions, resource, scoped: nil, &block)
          authorize(model, *actions, resource, scoped: scoped, raise_exception: true, &block)
        end

        def authorize(model, *actions, resource, scoped: nil, raise_exception: false)
          return yield if permissions(model, *actions, resource, scoped: scoped).any?

          raise NotAuthorized, not_authorized_msg(model, actions, resource, scoped) if raise_exception

          false
        end

        private

        def permissions(model, *actions, resource, scoped: nil)
          # TODO: Refactor to 1 query with joins
          roles_ids = model.assigned_roles.where(scoped: scoped).pluck(:role_id)
          permission_ids = Ez::Permissions::PermissionRole.where(role_id: roles_ids).pluck(:permission_id)

          Ez::Permissions::Permission.where(
            id:       permission_ids,
            resource: resource,
            action:   actions.map(&:to_s)
          )
        end

        def not_authorized_msg(model, actions, resource, scoped = nil)
          msg = "#{model.class}##{model.id} is not authorized to [#{actions.join(', ')} -> #{resource}]"
          msg = "#{msg} for #{scoped.class}##{scoped.id}" if scoped

          msg
        end
      end
    end
  end
end
