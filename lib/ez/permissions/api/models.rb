# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Models
        def assign_role(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          Ez::Permissions::ModelRole.find_or_create_by!(
            role:   role,
            model:  model,
            scoped: scoped
          )
        end

        def reject_role(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          Ez::Permissions::ModelRole.find_by(
            role:   role,
            model:  model,
            scoped: scoped
          )&.delete
        end
      end
    end
  end
end
