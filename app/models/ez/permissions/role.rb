# frozen_string_literal: true

module Ez
  module Permissions
    class Role < ApplicationRecord
      self.table_name = Ez::Permissions.config.roles_table_name

      # has_and_belongs_to_many :permissions
      # has_and_belongs_to_many :users, class_name: '::User'

      validates :name, presence: true
      validates :name, uniqueness: true
    end
  end
end
