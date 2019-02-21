# frozen_string_literal: true

module Ez
  module Permissions
    class InstallGenerator < Rails::Generators::Base
      def create_migration
        create_file 'config/initializers/ez_permissions.rb',
                    "Ez::Permissions.configure do |config|
  # config.permission_table_name = 'ez_permissions_permissions'
  # config.roles_table_name = 'ez_permissions_roles'
end
"
      end
    end
  end
end
