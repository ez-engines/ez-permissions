# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module Ez
  module Permissions
    class InstallGenerator < Rails::Generators::Base
      def create_migration
        create_file 'config/initializers/ez_permissions.rb',
                    "# frozen_string_literal: true

Ez::Permissions.configure do |config|
  # config.permissions_table_name = 'ez_permissions_permissions'
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

  # If you want to use permissions UI capabilities
  # require 'ez/permissions/ui'

  # Define your base UI controller
  # config.ui_base_controller = 'ApplicationController'
  # config.ui_base_routes = '/permissions'

  # Add custom code to Ez::Permissions::RolesController
  # config.ui_roles_controller_context = proc do
  #     before_action :authrozre_user!
  # end

  # Permissions UI ships with default generated CSS classes.
  # You always can inspect them in the browser and override
  # config.ui_custom_css_map = {
  #   'ez-permissions-roles-container' => 'you custom css classes here'
  # }
end
"
      end

      def create_locale_file
        create_file 'config/locales/ez_permissions.en.yml',
                    "en:
  ez_permissions:
    label: Permissions
    permissions:
      label: Permissions
    roles:
      label: Roles
      actions:
        add: Add
        edit: Edit
        remove: Remove
      fields:
        name: Name
        "
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
