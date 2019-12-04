# frozen_string_literal: true

module Ez
  module Permissions
    class ApplicationCell < Cell::ViewModel
      self.view_paths = ["#{Ez::Permissions::Engine.root}/app/cells"]

      # delegate :params, :request, to: :controller
      # delegate :dynamic_css_map,  to: :'interface.config'

      I18N_SCOPE    = 'ez_permissions'
      CSS_SCOPE     = 'ez-permissions'

      # def self.form
      #   include ActionView::Helpers::FormHelper
      #   include SimpleForm::ActionViewExtensions::FormHelper
      #   include ActionView::RecordIdentifier
      #   include ActionView::Helpers::FormOptionsHelper
      # end

      # def self.option(name, default: nil)
      #   define_method name do
      #     options[name]
      #   end
      # end

      def css_for(item)
        scoped_item = "#{CSS_SCOPE}-#{item}"

        custom_css_map[scoped_item] || scoped_item
      end

      def custom_css_map
        @custom_css_map ||= Ez::Permissions.config.ui_custom_css_map || {}
      end

      # def controller
      #   context[:controller]
      # end

      # def group_link(group, _options = {})
      #   link_to i18n_group_label(group),
      #           group_path(group),
      #           class: css_for(:nav_menu_item, dynamic: "permissions/#{group.name}")
      # end

      # def group_path(group)
      #   "#{interface.config.default_path}/#{group.name}"
      # end

      def t(args)
        I18n.t(args, scope: I18N_SCOPE)
      end

      # def i18n_group_description(group)
      #   t(DESCRIPTION, scope: [SCOPE, INTERFACES, group.interface, GROUPS, group.name],
      #                  default: group.name.to_s.humanize)
      # end

      # def i18n_key_label(key)
      #   t(LABEL, scope: [SCOPE, INTERFACES, key.interface, GROUPS, key.group, KEYS, key.name],
      #            default: key.name.to_s.humanize)
      # end
    end
  end
end
