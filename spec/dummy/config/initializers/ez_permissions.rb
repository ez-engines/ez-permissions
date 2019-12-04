# frozen_string_literal: true

Ez::Permissions.configure do |config|
  require 'ez/permissions/ui'
  config.ui_base_controller = 'ApplicationController'

  config.ui_roles_controller_context = proc do
    before_action do
      flash[:notice] = 'Roles controller before action works fine'
    end
  end

  config.ui_custom_css_map = {
    'ez-permissions-roles-container'              => 'dummy-roles-container',
    'ez-permissions-roles-inner-container'        => 'dummy-roles-inner-container',
    'ez-permissions-roles-add-button'             => 'dummy-roles-add-button',
    'ez-permissions-roles-add-button-container'   => 'dummy-roles-add-button-container',
    'ez-permissions-roles-header-container'       => 'dummy-roles-header-container',
    'ez-permissions-roles-header-inner-container' => 'dummy-roles-header-inner-container',
    'ez-permissions-roles-header-inner-container' => 'dummy-roles-header-inner-container',
    'ez-permissions-roles-header-label'           => 'dummy-roles-header-label',
    'ez-permissions-roles-table'                  => 'dummy-roles-table'
  }
end
