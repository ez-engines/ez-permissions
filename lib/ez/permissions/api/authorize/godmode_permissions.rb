# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Authorize
        class GodmodPermissions < ModelPermissions
          def can?(_action_name, _resource_name, **)
            true
          end

          def authorize!(_action_name, _resource_name, **)
            true
          end
        end
      end
    end
  end
end
