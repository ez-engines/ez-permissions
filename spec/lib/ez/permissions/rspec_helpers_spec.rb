# frozen_string_literal: true

require 'rails_helper'
require 'ez/permissions/rspec_helpers'

RSpec.describe Ez::Permissions::RSpecHelpers do
  include Ez::Permissions::RSpecHelpers

  let(:user)    { User.create! }
  let(:project) { Project.create! }

  describe '.seed_user_permissions' do
    let(:admin_role) { Ez::Permissions::Role.find_by(name: 'admin') }
    let(:create_users_permission) { Ez::Permissions::Permission.find_by!(resource: 'users', action: 'create') }
    let(:read_users_permission) { Ez::Permissions::Permission.find_by!(resource: 'users', action: 'read') }

    let(:create_users_permission_role) do
      Ez::Permissions::PermissionRole.find_by(
        role:       admin_role,
        permission: create_users_permission
      )
    end

    let(:read_users_permission_role) do
      Ez::Permissions::PermissionRole.find_by(
        role:       admin_role,
        permission: read_users_permission
      )
    end

    let(:assigned_user_role) { Ez::Permissions::ModelRole.find_by(role: admin_role, model: user, scoped: nil) }
    let(:assigned_scoped_role) { Ez::Permissions::ModelRole.find_by(role: admin_role, model: user, scoped: project) }

    context 'single action' do
      before { seed_user_permissions(user, :admin, :create, :users) }

      it { expect(admin_role).to be_present }
      it { expect(create_users_permission).to be_present }
      it { expect(create_users_permission_role).to be_present }
      it { expect(assigned_user_role).to be_present }
    end

    context 'multiple actions' do
      before { seed_user_permissions(user, :admin, :create, :read, :users) }

      it { expect(admin_role).to be_present }
      it { expect(create_users_permission).to be_present }
      it { expect(read_users_permission).to be_present }
      it { expect(create_users_permission_role).to be_present }
      it { expect(read_users_permission_role).to be_present }
      it { expect(assigned_user_role).to be_present }
    end

    context 'all actions' do
      before { seed_user_permissions(user, :admin, :all, :users) }

      it { expect(admin_role).to be_present }
      it { expect(create_users_permission).to be_present }
      it { expect(read_users_permission).to be_present }
      it { expect(create_users_permission_role).to be_present }
      it { expect(read_users_permission_role).to be_present }
      it { expect(assigned_user_role).to be_present }
    end

    context 'scoped' do
      before { seed_user_permissions(user, :admin, :create, :users, scoped: project) }

      it { expect(admin_role).to be_present }
      it { expect(create_users_permission).to be_present }
      it { expect(create_users_permission_role).to be_present }
      it { expect(assigned_user_role).not_to be_present }
      it { expect(assigned_scoped_role).to be_present }
    end
  end

  describe '.assume_user_permissions' do
    before { assume_user_permissions(user, :admin, :create, :users) }

    it 'mocks admin role' do
      admin_role = Ez::Permissions::API.get_role(:admin)

      expect(admin_role).to be_present
      expect(admin_role.id).to be_present
    end

    it 'mocks user permission as an admin' do
      expect(user.assigned_roles.size).to eq 1
      expect(user.assigned_roles.first.id).to be_present
      expect(user.assigned_roles.first.name).to eq 'admin'
    end

    it 'mocks user authorization' do
      expect(Ez::Permissions::API.can?(user, :create, :users)).to eq true
      expect(Ez::Permissions::API.can?(user, :read, :users)).to eq false
      expect(Ez::Permissions::API.can?(user, :create, :read, :users)).to eq false
    end
  end
end
