# frozen_string_literal: true

Ez::Permissions.configure do |config|
  require 'ez/permissions/ui'
  config.ui_base_controller = 'ApplicationController'
  config.ui_base_routes = '/permissions'

  config.ui_roles_controller_context = proc do
    before_action do
      flash[:notice] = 'Roles controller before action works fine'
    end
  end

  config.ui_permissions_controller_context = proc do
    before_action do
      flash[:notice] = 'Permissions controller before action works fine'
    end
  end

  config.ui_roles_actions = %i[edit remove]

  config.ui_custom_css_map = {
    'ez-permissions-container'              => 'dummy-container',
    'ez-permissions-inner-container'        => 'dummy-inner-container',
    'ez-permissions-add-button'             => 'dummy-add-button',
    'ez-permissions-add-button-container'   => 'dummy-add-button-container',
    'ez-permissions-header-container'       => 'dummy-header-container',
    'ez-permissions-header-inner-container' => 'dummy-header-inner-container',
    'ez-permissions-header-inner-container' => 'dummy-header-inner-container',
    'ez-permissions-header-label'           => 'dummy-header-label',
    'ez-permissions-table'                  => 'dummy-table',
    'ez-permissions-form-inner-container'   => 'dummy-form',
    'ez-permissions-form-field'             => 'dummy-form-field',
    'ez-permissions-table-thead-tr'         => 'dummy-table-thead-tr',
  }
end
