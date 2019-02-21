# frozen_string_literal: true

module Ez
  module Permissions
    class Permission < ApplicationRecord
      self.table_name = Ez::Permissions.config.permissions_table_name

      # has_and_belongs_to_many :roles

      validates :resource, presence: true
      validates :action, presence: true
    end
  end
end
