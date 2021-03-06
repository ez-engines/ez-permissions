# frozen_string_literal: true

module Ez
  module Permissions
    class Resource
      ACTIONS = %i[create read update delete].freeze

      attr_reader :name, :model, :actions, :group, :label

      def initialize(name, options = {})
        @name    = name
        @model   = options.fetch(:model, nil)
        @actions = process_actions(options.fetch(:actions, []))
        @group   = options.fetch(:group, :others)
        @label   = options.fetch(:label, name.to_s.humanize)
      end

      def <=>(other)
        name <=> other.name
      end

      private

      def process_actions(actions)
        return ACTIONS if actions.empty?

        actions.map { |action| action == :crud ? ACTIONS : action }.flatten
      end
    end
  end
end
