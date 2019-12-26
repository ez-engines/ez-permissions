# frozen_string_literal: true

module Ez
  module Permissions
    module Model
      # rubocop:disable Metrics/MethodLength
      def self.included(base)
        base.has_many :assigned_roles,
                      class_name: 'Ez::Permissions::ModelRole',
                      as: :model

        base.has_many :roles,
                      -> { distinct },
                      through: :assigned_roles,
                      class_name: 'Ez::Permissions::Role'

        base.has_many :permissions,
                      -> { distinct },
                      through: :roles,
                      class_name: 'Ez::Permissions::Permission'
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
