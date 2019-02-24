# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::Model do
  before { User.include Ez::Permissions::Model }

  let(:user) { User.create(email: 'user@dummy.test') }
  let(:project) { Project.create(name: 'Test') }

  describe 'relationships' do
    let!(:admin_role)      { Ez::Permissions::API.create_role(name: :admin) }
    let!(:supervisor_role) { Ez::Permissions::API.create_role(name: :supervisor) }
    let!(:user_role)       { Ez::Permissions::API.create_role(name: :user) }

    before do
      Ez::Permissions::API.assign_role(user, :admin)
      Ez::Permissions::API.assign_role(user, :admin, scoped: project)
      Ez::Permissions::API.assign_role(user, :supervisor)

      Ez::Permissions::API.grant_permission(:admin,      :create, :users)
      Ez::Permissions::API.grant_permission(:admin,      :read,   :users)
      Ez::Permissions::API.grant_permission(:supervisor, :create, :projects)
      Ez::Permissions::API.grant_permission(:user,       :read,   :projects)
    end

    it 'has many assigned roles' do
      expect(user.assigned_roles.size).to eq 3
      expect(user.assigned_roles.pluck(:role_id)).to eq([admin_role.id, admin_role.id, supervisor_role.id])
      expect(user.assigned_roles.pluck(:scoped_id)).to eq([nil, project.id, nil])
      expect(user.assigned_roles.pluck(:scoped_type)).to eq([nil, 'Project', nil])
      expect(user.assigned_roles.map(&:class).uniq).to eq [Ez::Permissions::ModelRole]
    end

    it 'has many unique roles' do
      expect(user.roles.size).to eq 2
      expect(user.roles.pluck(:id)).to eq([admin_role.id, supervisor_role.id])
      expect(user.roles.map(&:class).uniq).to eq [Ez::Permissions::Role]
    end

    it 'has many unqique permissions' do
      expect(user.permissions.size).to eq 3
      expect(user.permissions.map(&:resource)).to eq %w[users users projects]
      expect(user.permissions.map(&:action)).to eq %w[create read create]
    end
  end
end
