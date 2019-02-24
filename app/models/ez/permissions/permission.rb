# frozen_string_literal: true

module Ez
  module Permissions
    class Permission < ApplicationRecord
      self.table_name = Ez::Permissions.config.permissions_table_name

      validates :resource, presence: true
      validates :action, presence: true
    end
  end
end
