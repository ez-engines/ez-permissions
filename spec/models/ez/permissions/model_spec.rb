# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Permissions::Model do
  before { User.include Ez::Permissions::Model }

  let(:user) { User.create(email: 'user@dummy.test') }

  describe 'relationships' do
    it 'has many roles' do
      expect(user.roles).to eq([])
    end

    it 'has many roles' do
      expect(user.model_roles).to eq([])
    end

    it 'has many permissions' do
      expect(user.permissions).to eq([])
    end
  end
end
