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

  # By default, UI will not allow you to update and remove roles. It's dangerous
  # config.ui_roles_actions = %i[edit remove]

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
        submit: Submit
        cancel: Cancel
        permissions: Permissions
      fields:
        name: Name
      messages:
        invalid: Invalid input. Please, check the errors below
        update_warning: Warning! Changing role name can hurt your application
        remove_confirmation: Warning! Role removal can hurt your application. Are you sure?
        created: Role has been successfully created
        updated: Role has been successfully updated
        removed: Role has been successfully removed
        "
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
