# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren:
class ActionDispatch::Routing::Mapper
  def ez_permissions_ui_routes
    mount Ez::Permissions::Engine, at: '/permissions', as: :ez_permissions
  end
end
# rubocop:enable Style/ClassAndModuleChildren:
