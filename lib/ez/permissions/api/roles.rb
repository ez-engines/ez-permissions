# frozen_string_literal: true

module Ez
  module Permissions
    module API
      module Roles
        RoleNotFound = Class.new(StandardError)

        def list_roles
          Role.all
        end

        def create_role(name)
          Role.create(name: name)
        end

        def get_role(name)
          Role.find_by(name: name)
        end

        def get_role!(name)
          Role.find_by!(name: name)
        rescue ActiveRecord::RecordNotFound
          raise RoleNotFound, "Role #{name} not found"
        end

        def update_role(role_name, name:)
          role = get_role!(role_name)

          role.update(name: name)
        end

        def delete_role(name)
          role = get_role!(name)

          role.delete
        end
      end
    end
  end
end
