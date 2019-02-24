# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::API::Permissions do
  before { described_class.extend described_class }

  let!(:user_role) { Ez::Permissions::API.create_role(:user) }
  let(:read_project_permission) { described_class.get_permission!(:read, :projects) }

  describe '.get_permission!' do
    it 'returns permision record' do
      permission = described_class.get_permission!(:read, :projects)

      expect(permission.action).to eq 'read'
      expect(permission.resource).to eq 'projects'
    end

    it 'raise exception if permission does not exists' do
      expect do
        described_class.get_permission!(:foo, :bar)
      end.to raise_error(
        Ez::Permissions::API::Permissions::PermissionNotFound,
        'Permission [foo -> bar] not found'
      )
    end
  end

  describe '.add_permission' do
    it 'creates permission' do
      role_permission = described_class.grant_permission(:user, :read, :projects)

      expect(role_permission).to be_persisted
      expect(role_permission.role).to eq user_role
      expect(role_permission.permission).to eq read_project_permission
    end

    it 'skips creation on existing permission' do
      old_permission = described_class.grant_permission(:user, :read, :projects)
      new_permission = described_class.grant_permission(:user, :read, :projects)

      expect(old_permission).to eq new_permission
    end

    it 'grant all actions per resource' do
      described_class.grant_permission(:user, :all, :projects)

      Ez::Permissions::DSL.resource(:projects).actions.each do |action|
        permission = described_class.get_permission!(action, :projects)
        permission_role = Ez::Permissions::PermissionRole.find_by!(permission: permission, role: user_role)

        expect(permission_role).to be_persisted
      end
    end

    it 'raise exception if role does not exists' do
      expect do
        described_class.grant_permission(:dummy, :read, :projects)
      end.to raise_error(
        Ez::Permissions::API::Roles::RoleNotFound,
        'Role dummy not found'
      )
    end

    it 'raise exception if permission does not exists' do
      expect do
        described_class.grant_permission(:user, :foo, :bar)
      end.to raise_error(
        Ez::Permissions::API::Permissions::PermissionNotFound,
        'Permission [foo -> bar] not found'
      )
    end
  end

  describe '.revoke_permission' do
    it 'deletes permission role record' do
      role_permission = described_class.grant_permission(:user, :read, :projects)

      described_class.revoke_permission(:user, :read, :projects)

      expect do
        role_permission.reload
      end.to raise_error(
        ActiveRecord::RecordNotFound, "Couldn't find Ez::Permissions::PermissionRole with 'id'=#{role_permission.id}"
      )
    end

    it 'raise exception if role does not exists' do
      expect  do
        described_class.revoke_permission(:dummy, :read, :projects)
      end.to raise_error(
        Ez::Permissions::API::Roles::RoleNotFound,
        'Role dummy not found'
      )
    end

    it 'raise exception if permission does not exists' do
      expect  do
        described_class.revoke_permission(:user, :foo, :bar)
      end.to raise_error(
        Ez::Permissions::API::Permissions::PermissionNotFound,
        'Permission [foo -> bar] not found'
      )
    end
  end
end
