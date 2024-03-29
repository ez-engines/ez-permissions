# frozen_string_literal: true

module Ez
  module Permissions
    class Role < ApplicationRecord
      self.table_name = Ez::Permissions.config.roles_table_name

      has_and_belongs_to_many :permissions, join_table: Ez::Permissions.config.permissions_roles_table_name

      validates :name, presence: true
      validates :name, uniqueness: true

      before_validation do
        self.name = name&.parameterize
      end
    end
  end
end
