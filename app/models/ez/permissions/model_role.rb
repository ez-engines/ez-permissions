# frozen_string_literal: true

module Ez
  module Permissions
    class ModelRole < ApplicationRecord
      self.table_name = Ez::Permissions.config.models_roles_table_name

      belongs_to :model,  polymorphic: true
      belongs_to :scoped, polymorphic: true, optional: true
      belongs_to :role
    end
  end
end
