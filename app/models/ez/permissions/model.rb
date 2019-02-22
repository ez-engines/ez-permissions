# frozen_string_literal: true

module Ez
  module Permissions
    module Model
      def self.included(base)
        base.has_many :assigned_roles, class_name: 'Ez::Permissions::ModelRole', as: :model
        base.has_many :roles, through: :assigned_roles, source: :model, source_type: 'Ez::Permissions::Role'
        base.has_many :permissions, through: :roles, class_name: 'Ez::Permissions::Permission'
      end
    end
  end
end
