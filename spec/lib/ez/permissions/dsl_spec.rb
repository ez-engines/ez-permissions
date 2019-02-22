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

      expect(Ez::Permissions::DSL.resources[1].name).to eq :projects
      expect(Ez::Permissions::DSL.resources[1].actions).to eq %i[create read update delete custom]
      expect(Ez::Permissions::DSL.resources[1].model).to eq Project
    end
  end
end
