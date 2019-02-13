# frozen_string_literal: true

module Ez
  module Permissions
    class Permission < ApplicationRecord
      # has_and_belongs_to_many :roles

      validates :resource, presence: true
      validates :action, presence: true
    end
  end
end
