# frozen_string_literal: true

module Ez
  module Permissions
    module Roles
      class IndexCell < ApplicationCell
        def can_edit?
          available_actions.include?(:edit)
        end

        def can_remove?
          available_actions.include?(:remove)
        end

        private

        def available_actions
          @available_actions ||= Ez::Permissions.config.ui_roles_actions || []
        end
      end
    end
  end
end
