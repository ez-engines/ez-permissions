module Ez
  module Permissions
    class RolesController < Ez::Permissions::ApplicationController

      def index
        # view :index
      end

      private

      def collection
        @collection ||= Ez::Permissions::Role.all
      end
    end
  end
end
