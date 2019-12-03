module Ez
  module Permissions
    class ApplicationController < Ez::Permissions.config.base_controller.constantize
      protect_from_forgery with: :exception

      def view(cell_name, *args)
        render html: cell("ez/settings/#{cell_name}", *args), layout: true
      end
    end
  end
end
