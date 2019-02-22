# frozen_string_literal: true

module Ez
  module Permissions
    class ModelRole < ApplicationRecord
      self.table_name = Ez::Permissions.config.model_roles_table_name

      belongs_to :model,  polymorphic: true
      belongs_to :scoped, polymorphic: true
    end
  end
end
