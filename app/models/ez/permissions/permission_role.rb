# frozen_string_literal: true

module Ez
  module Permissions
    class PermissionRole < ApplicationRecord
      self.table_name = Ez::Permissions.config.permissions_roles_table_name

      belongs_to :permission, class_name: 'Ez::Permissions::Permission'
      belongs_to :role,       class_name: 'Ez::Permissions::Role'
    end
  end
end
