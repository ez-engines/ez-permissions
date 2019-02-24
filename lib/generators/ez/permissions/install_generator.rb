# frozen_string_literal: true

module Ez
  module Permissions
    class InstallGenerator < Rails::Generators::Base
      def create_migration
        create_file 'config/initializers/ez_permissions.rb',
                    "# frozen_string_literal: true

Ez::Permissions.configure do |config|
  # config.permission_table_name = 'ez_permissions_permissions'
  # config.roles_table_name = 'ez_permissions_roles'
  # config.models_roles_table_name = 'ez_permissions_model_roles'
  # config.permissions_roles_table_name = 'ez_permissions_permissions_roles'

  # config.handle_no_permission_model = lambda { |context|
  #   here you can define your custom callback
  #   in case when permission model (user) is nil
  # }

  # config.handle_not_authorized = lambda { |context|
  #  here you can define your custom callback
  #  in case when model (user) is not authorized
  # }
end
"
      end
    end
  end
end
