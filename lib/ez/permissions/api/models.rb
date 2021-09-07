# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Models
        def assign_role(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          Ez::Permissions::ModelRole.find_or_create_by!(
            role: role,
            model: model,
            scoped: scoped
          )
        end

        def reject_role(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          model_role(role, model, scoped)&.delete
        end

        def includes_role?(model, role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          model_role(role, model, scoped) ? true : false
        end

        def list_by_role(role_name, scoped: nil)
          role = Ez::Permissions::API.get_role!(role_name)

          Ez::Permissions::ModelRole.where(
            role: role,
            scoped: scoped
          ).map(&:model)
        end

        private

        def model_role(role, model, scoped)
          Ez::Permissions::ModelRole.find_by(
            role: role,
            model: model,
            scoped: scoped
          )
        end
      end
    end
  end
end
