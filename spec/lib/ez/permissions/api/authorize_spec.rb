# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::API::Authorize do
  before { described_class.extend described_class }

  let(:user) { User.create!(email: 'user@dummy.test') }

  let!(:admin_role) { Ez::Permissions::API.create_role(:admin) }
  let!(:user_role) { Ez::Permissions::API.create_role(:user) }

  let(:project) { Project.create!(name: 'Test') }

  let(:dummy_code) { double(:dummy, call: true) }

  before do
    Ez::Permissions::API.grant_permission(:admin, :all, :users)
    Ez::Permissions::API.grant_permission(:user, :read, :users)
  end

  describe '.authorize!' do
    context 'has no roles' do
      before do
        expect(user.assigned_roles).to eq([])
        expect(dummy_code).not_to receive(:call)
      end

      it 'fails try access to resource' do
        expect do
          described_class.authorize!(user, :create, :users) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create -> users]"
        )
      end

      it 'fails try access to scoped resource' do
        expect do
          described_class.authorize!(user, :create, :update, :users, scoped: project) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create, update -> users] for Project##{project.id}"
        )
      end
    end

    context 'has one global role' do
      it 'execute block if admin' do
        Ez::Permissions::API.assign_role(user, :admin)

        expect(dummy_code).to receive(:call)

        described_class.authorize!(user, :create, :read, :update, :delete, :users) { dummy_code.call }
      end

      it 'execute block if user' do
        Ez::Permissions::API.assign_role(user, :user)

        expect(dummy_code).to receive(:call)

        described_class.authorize!(user, :read, :users) { dummy_code.call }
      end

      it 'execute block if admin & user' do
        Ez::Permissions::API.assign_role(user, :admin)
        Ez::Permissions::API.assign_role(user, :user)

        expect(dummy_code).to receive(:call)

        described_class.authorize!(user, :create, :delete, :users) { dummy_code.call }
      end

      it 'fails if user' do
        Ez::Permissions::API.assign_role(user, :user)

        expect(dummy_code).not_to receive(:call)

        expect do
          described_class.authorize!(user, :create, :users) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create -> users]"
        )
      end

      it 'fails without permissions' do
        expect(dummy_code).not_to receive(:call)

        expect do
          described_class.authorize!(user, :create, :users) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create -> users]"
        )
      end

      it 'fails with scoped role and global resource' do
        Ez::Permissions::API.assign_role(user, :admin, scoped: project)

        expect(dummy_code).not_to receive(:call)

        expect do
          described_class.authorize!(user, :create, :users) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create -> users]"
        )
      end

      it 'fails with scoped resource and global role' do
        Ez::Permissions::API.assign_role(user, :admin)

        expect(dummy_code).not_to receive(:call)

        expect do
          described_class.authorize!(user, :create, :users, scoped: project) { dummy_code.call }
        end.to raise_error(
          Ez::Permissions::API::Authorize::NotAuthorized,
          "User##{user.id} is not authorized to [create -> users] for Project##{project.id}"
        )
      end
    end
  end

  describe '.authorize' do
    context 'withour callbacks' do
      it 'execute block if admin' do
        Ez::Permissions::API.assign_role(user, :admin)

        expect(dummy_code).to receive(:call)

        expect(described_class.authorize(user, :create, :users) { dummy_code.call }).to eq true
      end

      it 'false if user' do
        Ez::Permissions::API.assign_role(user, :user)

        expect(dummy_code).not_to receive(:call)

        expect(described_class.authorize(user, :create, :users) { dummy_code.call }).to eq false
      end

      it 'false without permissions' do
        expect(dummy_code).not_to receive(:call)

        expect(described_class.authorize(user, :create, :users) { dummy_code.call }).to eq false
      end
    end

    context 'with callbacks' do
      let(:no_model_callback)       { double :no_model_callback, call: true }
      let(:not_authorized_callback) { double :no_user_callback, call: true }

      around do |example|
        Ez::Permissions.config.handle_no_permission_model = lambda { |_ctx|
          no_model_callback.call
        }

        Ez::Permissions.config.handle_not_authorized = lambda { |_ctx|
          not_authorized_callback.call
        }

        example.run

        Ez::Permissions.config.handle_no_permission_model = nil
        Ez::Permissions.config.handle_not_authorized = nil
      end

      it 'execute no_model_callback' do
        expect(no_model_callback).to receive(:call)

        described_class.authorize(nil, :create, :users) { 'code' }
      end

      it 'execute not_authorized_callback' do
        expect(not_authorized_callback).to receive(:call)

        described_class.authorize(user, :create, :users) { 'code' }
      end
    end
  end

  describe '.can?' do
    context 'has no roles' do
      before do
        expect(user.assigned_roles).to eq([])
        expect(dummy_code).not_to receive(:call)
      end

      it 'false try access to resource' do
        expect(described_class.can?(user, :create, :users)).to eq false
      end

      it 'false try access to scoped resource' do
        expect(described_class.can?(user, :create, :users)).to eq false
      end
    end

    context 'has one global role' do
      it 'true if admin' do
        Ez::Permissions::API.assign_role(user, :admin)

        expect(described_class.can?(user, :create, :read, :update, :delete, :users)).to eq true
      end

      it 'true if user' do
        Ez::Permissions::API.assign_role(user, :user)

        expect(described_class.can?(user, :create, :read, :update, :delete, :users)).to eq true
      end

      it 'true if admin & user' do
        Ez::Permissions::API.assign_role(user, :admin)
        Ez::Permissions::API.assign_role(user, :user)

        expect(described_class.can?(user, :create, :read, :update, :delete, :users)).to eq true
      end

      it 'false if user' do
        Ez::Permissions::API.assign_role(user, :user)

        expect(described_class.can?(user, :create, :users)).to eq false
      end

      it 'false without permissions' do
        expect(described_class.can?(user, :create, :users)).to eq false
      end

      it 'false with scoped role and global resource' do
        Ez::Permissions::API.assign_role(user, :admin, scoped: project)

        expect(described_class.can?(user, :create, :users)).to eq false
      end

      it 'false with scoped resource and global role' do
        Ez::Permissions::API.assign_role(user, :admin)

        expect(described_class.can?(user, :create, :users, scoped: project)).to eq false
      end
    end
  end
end
