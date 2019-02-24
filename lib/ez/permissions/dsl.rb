# frozen_string_literal: true

require_relative 'resource'

module Ez
  module Permissions
    class DSL
      include Singleton

      def self.define
        yield DSL.instance
      end

      def self.resources
        DSL.instance.resources
      end

      def self.resource(name)
        DSL.instance.resources.find { |r| r.name.to_sym == name.to_sym }
      end

      attr_reader :resources

      def initialize
        @resources = []
      end

      def add(name, options = {})
        if self.class.resource(name)
          return message("[WARN] Ez::Permissions resource [#{name}] has been already defined!")
        end

        resource = Ez::Permissions::Resource.new(name, options)

        message(
          "[SUCCESS] Ez::Permissions resource [#{name}] has been successfully registred with actions: \
[#{resource.actions.join(', ')}]"
        )

        @resources << resource
        seed_to_db resource
      end

      private

      def message(txt)
        STDOUT.puts(txt)
      end

      def seed_to_db(resource)
        begin
          ActiveRecord::Base.connection
        rescue ActiveRecord::NoDatabaseError
          return STDOUT.puts 'Database does not exist'
        end

        return unless ActiveRecord::Base.connection.data_source_exists?(Ez::Permissions.config.permissions_table_name)

        return unless resource.actions

        resource.actions.each do |action|
          Ez::Permissions::Permission.where(
            resource: resource.name,
            action:   action
          ).first_or_create!
        end
      end
    end
  end
end
