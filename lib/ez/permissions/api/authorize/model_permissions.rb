# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Authorize
        class ModelPermissions
          attr_reader :permissions_map

          def initialize(permissions_map)
            @permissions_map = permissions_map
          end

          def can?(action_name, resource_name, scoped: nil)
            permissions_map[to_key(action_name, resource_name, scoped)] == true
          end

          def authorize!(action_name, resource_name, scoped: nil)
            permissions_map.fetch(to_key(action_name, resource_name, scoped))
          rescue KeyError
            raise Ez::Permissions::NotAuthorizedError
          end

          private

          def to_key(action_name, resource_name, scoped = nil)
            scoped_key = [scoped&.class, scoped&.id].compact.join("_")
            "#{action_name}_#{resource_name}_#{scoped_key}".to_sym
          end
        end
      end
    end
  end
end
