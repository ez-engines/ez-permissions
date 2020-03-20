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

      def self.resource_action?(resource_name, action_name)
        registed_resource = resource(resource_name)
        action = registed_resource.actions.include?(action_name.to_sym) if registed_resource

        registed_resource && action ? true : false
      end

      attr_reader :resources

      def initialize
        @resources = []
      end

      def add(name, options = {})
        return message("Resource [#{name}] has been already defined!") if self.class.resource(name)

        resource = Ez::Permissions::Resource.new(name, options)

        @resources << resource

        return unless seed_to_db(resource)

        message(
          "Resource [#{name}] has been successfully registered with actions: [#{resource.actions.join(', ')}]",
          'SUCCESS'
        )
      end

      private

      def message(txt, level = 'WARN')
        return if Ez::Permissions.config.mute_stdout

        STDOUT.puts("[#{level}] Ez::Permissions: #{txt}")
      end

      def seed_to_db(resource)
        return unless try_db_connection
        return unless check_permissions_table

        resource.actions.each do |action|
          Ez::Permissions::Permission.where(
            resource: resource.name,
            action:   action
          ).first_or_create!
        end
      end

      def try_db_connection
        ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError
        message('Database does not exist')
        false
      end

      def check_permissions_table
        permissions_table = Ez::Permissions.config.permissions_table_name
        return true if ActiveRecord::Base.connection.data_source_exists?(permissions_table)

        message("Table #{permissions_table} does not exists. Please, check migrations")
        false
      end
    end
  end
end
