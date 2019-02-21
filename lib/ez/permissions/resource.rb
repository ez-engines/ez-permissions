# frozen_string_literal: true

module Ez
  module Permissions
    class Resource
      ACTIONS = %i[create read update delete].freeze

      attr_reader :name, :model, :actions

      def initialize(name, options = {})
        @name    = name
        @model   = options.fetch(:model, nil)
        @actions = process_actions(options.fetch(:actions, nil))
      end

      def <=>(other)
        name <=> other.name
      end

      private

      def process_actions(actions)
        return ACTIONS unless actions

        actions.map { |action| action == :crud ? ACTIONS : action }.flatten
      end
    end
  end
end
