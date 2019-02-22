# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Models
        RoleNotFound = Class.new(StandardError)

        def assign_role(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          Ez::Permissions::ModelRole.find_or_create_by!(
            role:   role,
            model:  model,
            scoped: scoped
          )
        end

        # TODO: refuse role
      end
    end
  end
end
