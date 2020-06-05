# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::API::Models do
  before { described_class.extend described_class }

  let(:user) { User.create!(email: 'user@dummy.test') }
  let!(:admin_role) { Ez::Permissions::API.create_role(:admin) }
  let(:project) { Project.create!(name: 'Test') }

  describe 'includes_role?' do
    before { Ez::Permissions::API.create_role(:manager) }

    context 'user includes particular global role' do
      it 'returns true' do
        described_class.assign_role(user, :admin)
        described_class.assign_role(user, :manager)

        expect(described_class.includes_role?(user, :manager)).to eq true
      end
    end

    context 'user includes particular scoped role' do
      it 'returns true' do
        described_class.assign_role(user, :admin)
        described_class.assign_role(user, :manager, scoped: project)

        expect(described_class.includes_role?(user, :manager, scoped: project)).to eq true
        expect(described_class.includes_role?(user, :manager)).to eq false
      end
    end

    context 'user does not include particular global role' do
      it 'returns false' do
        described_class.assign_role(user, :admin)

        expect(described_class.includes_role?(user, :manager)).to eq false
      end
    end

    context 'user does not include particular scoped role' do
      it 'returns false' do
        described_class.assign_role(user, :manager)

        expect(described_class.includes_role?(user, :manager, scoped: project)).to eq false
        expect(described_class.includes_role?(user, :manager)).to eq true
      end
    end
  end

  describe 'assign_role' do
    it 'assign role to the user' do
      described_class.assign_role(user, :admin)

      aggregate_failures do
        expect(user.assigned_roles.count).to eq 1
        expect(user.assigned_roles.pluck(:role_id)).to eq [admin_role.id]
      end
    end

    it 'assign multiple unique roles to the user' do
      manager_role = Ez::Permissions::API.create_role(:manager)

      described_class.assign_role(user, :admin)
      described_class.assign_role(user, :manager)
      described_class.assign_role(user, :manager)

      aggregate_failures do
        expect(user.assigned_roles.count).to eq 2
        expect(user.assigned_roles.pluck(:role_id)).to eq [admin_role.id, manager_role.id]
      end
    end

    it 'assign scoped roles to the user' do
      manager_role = Ez::Permissions::API.create_role(:manager)
      worker_role = Ez::Permissions::API.create_role(:worker)

      described_class.assign_role(user, :admin)
      described_class.assign_role(user, :manager, scoped: project)
      described_class.assign_role(user, :worker,  scoped: project)

      aggregate_failures do
        expect(user.assigned_roles.count).to eq 3
        expect(user.assigned_roles.pluck(:role_id)).to eq [admin_role.id, manager_role.id, worker_role.id]
        expect(user.assigned_roles.pluck(:scoped_type)).to eq [nil, 'Project', 'Project']
        expect(user.assigned_roles.pluck(:scoped_id)).to eq [nil, project.id, project.id]
      end
    end
  end

  describe 'reject_role' do
    it 'rejects role from the user' do
      aggregate_failures do
        described_class.assign_role(user, :admin)
        expect(user.assigned_roles.count).to eq 1

        described_class.reject_role(user, :admin)
        expect(user.assigned_roles.count).to eq 0
      end
    end

    it 'raise exception when rejecting not existing role' do
      expect do
        described_class.reject_role(user, :dummy)
      end.to raise_error(
        Ez::Permissions::API::Roles::RoleNotFound,
        'Role dummy not found'
      )
    end
  end

  describe '.list_by_role' do
    let!(:manager_role) { Ez::Permissions::API.create_role(:manager) }

    let(:user1) { User.create!(email: 'user1@dummy.test') }
    let(:user2) { User.create!(email: 'user2@dummy.test') }
    let(:user3) { User.create!(email: 'user3@dummy.test') }
    let(:user4) { User.create!(email: 'user4@dummy.test') }

    let(:project1) { Project.create!(name: 'Project 1') }
    let(:project2) { Project.create!(name: 'Project 2') }

    before do
      described_class.assign_role(user1, :manager, scoped: project1)
      described_class.assign_role(user2, :manager, scoped: project1)
      described_class.assign_role(user3, :manager, scoped: project2)
      described_class.assign_role(user4, :manager)
    end

    context 'with scoped' do
      it 'returns objects with particular role in particular scope' do
        expect(described_class.list_by_role(:manager, scoped: project1)).to contain_exactly(user1, user2)
      end
    end

    context 'without scoped' do
      it 'returns objects with particular role without scope' do
        expect(described_class.list_by_role(:manager)).to contain_exactly(user4)
      end
    end
  end
end
