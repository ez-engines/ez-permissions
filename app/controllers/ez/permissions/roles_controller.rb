# frozen_string_literal: true

module Ez
  module Permissions
    class RolesController < Ez::Permissions::ApplicationController
      if Ez::Permissions.config.ui_roles_controller_context
        instance_exec(&Ez::Permissions.config.ui_roles_controller_context)
      end

      def index
        view 'roles/index', Ez::Permissions::Role.all
      end

      def new
        view 'roles/form', Ez::Permissions::Role.new
      end

      def create
        @role = Ez::Permissions::Role.new(role_params)

        if @role.save
          redirect_to(
            Ez::Permissions.config.ui_base_routes,
            notice: t('roles.messages.created', scope: ApplicationCell::I18N_SCOPE)
          )
        else
          flash[:alert] = t('roles.messages.invalid', scope: ApplicationCell::I18N_SCOPE)
          view 'roles/form', @role
        end
      end

      def edit
        flash[:alert] = t('roles.messages.update_warning', scope: ApplicationCell::I18N_SCOPE)
        view 'roles/form', role
      end

      def update
        if role.update(role_params)
          redirect_to(
            Ez::Permissions.config.ui_base_routes,
            notice: t('roles.messages.created', scope: ApplicationCell::I18N_SCOPE)
          )
        else
          flash[:alert] = t('roles.messages.invalid', scope: ApplicationCell::I18N_SCOPE)
          view 'roles/form', role
        end
      end

      def destroy
        role.destroy
        flash[:alert] = t('roles.messages.removed', scope: ApplicationCell::I18N_SCOPE)
        redirect_to Ez::Permissions.config.ui_base_routes
      end

      private

      def role
        @role ||= Ez::Permissions::Role.find(params[:id])
      end

      def role_params
        params.require(:role).permit(:name)
      end
    end
  end
end
