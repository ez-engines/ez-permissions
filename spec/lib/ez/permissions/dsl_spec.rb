# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::DSL do
  self.use_transactional_tests = false

  describe '.define' do
    before do
      Ez::Permissions::DSL.define do |setup|
        setup.add :roles,       model: Ez::Permissions::Role, actions: %i[create read]
        setup.add :permissions, model: Ez::Permissions::Permission, actions: %i[crud custom]
      end
    end

    let(:model) { Ez::Permissions::Permission }

    it 'seeds db with defined resource and actions' do
      aggregate_failures do
        expect(model.count).to eq 7
        expect(model.find_by(resource: 'roles',       action: 'create')).to be_present
        expect(model.find_by(resource: 'roles',       action: 'read')).to be_present
        expect(model.find_by(resource: 'permissions', action: 'create')).to be_present
        expect(model.find_by(resource: 'permissions', action: 'read')).to be_present
        expect(model.find_by(resource: 'permissions', action: 'update')).to be_present
        expect(model.find_by(resource: 'permissions', action: 'delete')).to be_present
        expect(model.find_by(resource: 'permissions', action: 'custom')).to be_present
      end
    end

    it 'defines resources collection' do
      expect(Ez::Permissions::DSL.resources.count).to eq 2

      expect(Ez::Permissions::DSL.resources[0].name).to eq :roles
      expect(Ez::Permissions::DSL.resources[0].actions).to eq %i[create read]
      expect(Ez::Permissions::DSL.resources[0].model).to eq Ez::Permissions::Role

      expect(Ez::Permissions::DSL.resources[1].name).to eq :permissions
      expect(Ez::Permissions::DSL.resources[1].actions).to eq %i[create read update delete custom]
      expect(Ez::Permissions::DSL.resources[1].model).to eq Ez::Permissions::Permission
    end
  end
end
