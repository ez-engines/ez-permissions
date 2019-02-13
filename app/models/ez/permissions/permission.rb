# frozen_string_literal: true

module Ez
  module Permissions
    class Permission < ApplicationRecord
      self.table_name = 'ez_permissions_permissions'

      has_and_belongs_to_many :roles
    end
  end
end
