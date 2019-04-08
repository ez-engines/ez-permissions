# frozen_string_literal: true

# rubocop:disable all
module Ez
  module Permissions
    module RSpecHelpers
      def seed_user_permissions(user, role, *actions, resource, scoped: nil)
        Ez::Permissions::API.create_role(role)

        actions.each do |action|
          Ez::Permissions::API.grant_permission(role, action, resource)
        end

        Ez::Permissions::API.assign_role(user, role, scoped: scoped)
      end

      def assume_user_permissions(model, role, *actions, resource, scoped: nil)
        # ROLE
        mocked_role = mock_role(role) # ROLE

        # MODEL ROLE
        allow(Ez::Permissions::ModelRole).to receive(:find_by).with(
          role:   mocked_role,
          model:  model,
          scoped: scoped
        ).and_return(mock_model_role(mocked_role, model, scoped: scoped))

        # PERMISSIONS
        mocked_permissions = actions.map { |action| mock_permission(resource, action) }

        # USER ROLES
        mocked_assiges_roles = double(:mocked_assiges_roles, where: [], size: 1, first: mocked_role)
        mocked_roles = double(:mocked_roles, pluck: [])

        # USER PERMISSION MODEL
        allow(model).to receive(:assigned_roles).and_return(mocked_assiges_roles)
        allow(mocked_assiges_roles).to receive(:where).with(scoped: scoped).and_return(mocked_roles)
        allow(mocked_roles).to receive(:pluck).with(:role_id).and_return [mocked_role.id]

        mocked_permission_role = double(:mocked_permission_role, pluck: [])
        allow(Ez::Permissions::PermissionRole).to receive(:where).with(role_id: [mocked_role.id]).and_return(mocked_permission_role)
        allow(mocked_permission_role).to receive(:pluck).with(:permission_id).and_return(mocked_permissions.map(&:id))

        # USER PERMISSION MODEL for scoped access
        mocked_empty_permission_role = double(:mocked_permission_role, pluck: [])
        allow(Ez::Permissions::PermissionRole).to receive(:where).with(role_id: []).and_return(mocked_empty_permission_role)
        allow(mocked_empty_permission_role).to receive(:pluck).with(:permission_id).and_return([])

        # PERMISSIONS
        allow(Ez::Permissions::Permission).to receive(:where).with(
          id:       mocked_permissions.map(&:id),
          resource: resource,
          action:   actions.map(&:to_s)
        ).and_return(mocked_permissions)

        # PERMISSIONS missing for all other actions
        other_resource_actions = Ez::Permissions::DSL.resource(resource).actions.reject { |a| actions.include?(a) }.map(&:to_s)

        allow(Ez::Permissions::Permission).to receive(:where).with(
          id:       mocked_permissions.map(&:id),
          resource: resource,
          action:   other_resource_actions
        ).and_return([])

        # PERMISSIONS missing for scoped access
        allow(Ez::Permissions::Permission).to receive(:where).with(
          id:       [],
          resource: resource,
          action:   actions.map(&:to_s)
        ).and_return([])
      end

      def mock_role(name, has: [], has_not: [], scoped: nil)
        mocked_role = double(:role, id: rand(1..99_999), name: name.to_s)

        allow(Ez::Permissions::Role).to receive(:find_by).with(name: name).and_return(mocked_role)
        allow(Ez::Permissions::Role).to receive(:find_by!).with(name: name).and_return(mocked_role)

        has.each do |model|
          mock_model_role(mocked_role, model, scoped: scoped)
        end

        has_not.each do |model|
          allow(Ez::Permissions::ModelRole).to receive(:find_by).with(
            role:   mocked_role,
            model:  model,
            scoped: scoped
          ).and_return(nil)
        end

        # Allow any model to assign the role
        allow(Ez::Permissions::ModelRole).to receive(:find_or_create_by!).with(
          role:   mocked_role,
          model:  anything,
          scoped: scoped
        ).and_return(double(:mocked_model_role))

        mocked_role
      end

      def mock_model_role(role, model, scoped: nil)
        mocked_model_role = double(:mocked_model_role, role: role, model: model, scoped: scoped)

        allow(Ez::Permissions::ModelRole).to receive(:find_by).with(
          role:   role,
          model:  model,
          scoped: scoped
        ).and_return(mocked_model_role)

        allow(Ez::Permissions::ModelRole).to receive(:find_or_create_by!).with(
          role:   role,
          model:  model,
          scoped: scoped
        ).and_return(mocked_model_role)
      end

      def mock_permission(resource, action)
        mocked_permission = double(:permission, id: rand(1..99_999), resource: resource.to_s, action: action.to_s)

        allow(Ez::Permissions::Permission)
          .to receive(:find_by!)
          .with(resource: resource, action: action)
          .and_return(mocked_permission)

        mocked_permission
      end
    end
  end
end
# rubocop:enable all
