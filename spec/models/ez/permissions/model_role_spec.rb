# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::ModelRole do
  let(:user) { User.create(email: 'user@dummy.test') }
  let(:project) { Project.create(name: 'Test') }
  let(:role) { Ez::Permissions::API.create_role(:user) }

  let(:model_role) { described_class.create!(role: role, model: user, scoped: project) }

  describe 'relationships' do
    it 'belongs to model' do
      expect(model_role.model).to eq user
    end

    it 'belongs to scoped' do
      expect(model_role.scoped).to eq project
    end
  end
end
