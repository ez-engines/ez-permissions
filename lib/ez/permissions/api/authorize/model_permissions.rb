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

          def can?(action_name, resource_name)
            permissions_map[to_key(action_name, resource_name)] == true
          end

          def authorize!(action_name, resource_name)
            permissions_map.fetch(to_key(action_name, resource_name))
          rescue KeyError => ex
            raise Ez::Permissions::NotAuthorizedError
          end

          private

          def to_key(action_name, resource_name)
            "#{action_name}_#{resource_name}".to_sym
          end
        end
      end
    end
  end
end
