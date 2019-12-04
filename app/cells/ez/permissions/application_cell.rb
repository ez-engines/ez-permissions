# frozen_string_literal: true

module Ez
  module Permissions
    class ApplicationCell < Cell::ViewModel
      self.view_paths = ["#{Ez::Permissions::Engine.root}/app/cells"]

      I18N_SCOPE    = 'ez_permissions'
      CSS_SCOPE     = 'ez-permissions'
      BASE_ROUTES   = Ez::Permissions.config.ui_base_routes || '/permissions'

      def self.form
        include ActionView::Helpers::FormHelper
        include SimpleForm::ActionViewExtensions::FormHelper
        include ActionView::RecordIdentifier
        include ActionView::Helpers::FormOptionsHelper
      end

      def div_for(item, &block)
        content_tag :div, class: css_for(item), &block
      end

      def css_for(item)
        scoped_item = "#{CSS_SCOPE}-#{item}"

        custom_css_map[scoped_item] || scoped_item
      end

      def custom_css_map
        @custom_css_map ||= Ez::Permissions.config.ui_custom_css_map || {}
      end

      def t(args)
        I18n.t(args, scope: I18N_SCOPE)
      end

      def path_for(tail = nil)
        [BASE_ROUTES, tail].join('/')
      end
    end
  end
end
