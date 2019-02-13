# frozen_string_literal: true

module Ez
  module Permissions
    class Role < ApplicationRecord
      # TODO
      # has_and_belongs_to_many :permissions
      # has_and_belongs_to_many :users, class_name: '::User'

      validates :name, presence: true
    end
  end
end
