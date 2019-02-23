# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::API::Models do
  before { described_class.extend described_class }

  let(:user) { User.create!(email: 'user@dummy.test') }
  let!(:admin_role) { Ez::Permissions::API.create_role(name: :admin) }
  let(:project) { Project.create!(name: 'Test') }

  describe 'assign_role' do
    it 'assign role to the user' do
      described_class.assign_role(user, :admin)

      aggregate_failures do
        expect(user.assigned_roles.count).to eq 1
        expect(user.assigned_roles.pluck(:role_id)).to eq [admin_role.id]
      end
    end

    it 'assign multiple unique roles to the user' do
      manager_role = Ez::Permissions::API.create_role(name: :manager)

      described_class.assign_role(user, :admin)
      described_class.assign_role(user, :manager)
      described_class.assign_role(user, :manager)

      aggregate_failures do
        expect(user.assigned_roles.count).to eq 2
        expect(user.assigned_roles.pluck(:role_id)).to eq [admin_role.id, manager_role.id]
      end
    end

    it 'assign scoped roles to the user' do
      manager_role = Ez::Permissions::API.create_role(name: :manager)
      worker_role = Ez::Permissions::API.create_role(name: :worker)

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
end
