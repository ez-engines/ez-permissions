# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::DSL do
  self.use_transactional_tests = false

  describe '.define' do
    let(:model) { Ez::Permissions::Permission }

    it 'seeds db with defined resource and actions' do
      aggregate_failures do
        expect(model.count).to eq 7
        expect(model.find_by(resource: 'users',    action: 'create')).to be_present
        expect(model.find_by(resource: 'users',    action: 'read')).to be_present
        expect(model.find_by(resource: 'projects', action: 'create')).to be_present
        expect(model.find_by(resource: 'projects', action: 'read')).to be_present
        expect(model.find_by(resource: 'projects', action: 'update')).to be_present
        expect(model.find_by(resource: 'projects', action: 'delete')).to be_present
        expect(model.find_by(resource: 'projects', action: 'custom')).to be_present
      end
    end

    it 'defines resources collection' do
      expect(Ez::Permissions::DSL.resources.count).to eq 2

      expect(Ez::Permissions::DSL.resources[0].name).to eq :users
      expect(Ez::Permissions::DSL.resources[0].actions).to eq %i[create read]
      expect(Ez::Permissions::DSL.resources[0].model).to eq User
      expect(Ez::Permissions::DSL.resources[0].group).to eq :accounts

      expect(Ez::Permissions::DSL.resources[1].name).to eq :projects
      expect(Ez::Permissions::DSL.resources[1].actions).to eq %i[create read update delete custom]
      expect(Ez::Permissions::DSL.resources[1].model).to eq Project
      expect(Ez::Permissions::DSL.resources[1].group).to eq :others
    end

    context 'log messages to STDOUT' do
      it 'log message if resources has been already defined' do
        expect(STDOUT).to receive(:puts).with('[WARN] Ez::Permissions: Resource [users] has been already defined!')

        Ez::Permissions::DSL.define do |setup|
          setup.add :users, actions: %i[create], model: User
        end
      end

      it 'log message if db connection missing' do
        allow(ActiveRecord::Base).to receive(:connection).and_raise(ActiveRecord::NoDatabaseError)

        expect(STDOUT).to receive(:puts).with('[WARN] Ez::Permissions: Database does not exist')

        Ez::Permissions::DSL.define do |setup|
          setup.add :dummies, actions: %i[create], model: User
        end
      end

      it 'log message if db migrations not passed' do
        allow(ActiveRecord::Base.connection)
          .to receive(:data_source_exists?)
          .with('ez_permissions_permissions')
          .and_return(false)

        expect(STDOUT)
          .to receive(:puts)
          .with('[WARN] Ez::Permissions: Table ez_permissions_permissions does not exists. Please, check migrations')

        Ez::Permissions::DSL.define do |setup|
          setup.add :other_dummies, actions: %i[create], model: User
        end
      end

      it 'suppress STDOUT if config.mute_stdout' do
        Ez::Permissions.config.mute_stdout = true

        Ez::Permissions::DSL.define do |setup|
          setup.add :other_dummies, actions: %i[create], model: User
        end

        expect(STDOUT).not_to receive(:puts)

        Ez::Permissions.config.mute_stdout = false
      end
    end
  end

  describe '.resources'
  describe '.resource'
  describe '.has_resource_action?'
end
