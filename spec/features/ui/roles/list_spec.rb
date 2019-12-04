# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List roles' do
  before do
    Ez::Permissions::API.create_role(:admin)
    Ez::Permissions::API.create_role(:manager)
  end

  scenario 'success' do
    visit '/permissions'

    expect(page).to have_current_path('/permissions')
    expect(page).to have_content('Roles')

    within('.notice') do
      expect(page).to have_content 'Roles controller before action works fine'
    end

    within('tr#role-admin') do
      expect(page).to have_content 'Admin'
    end

    within('tr#role-manager') do
      expect(page).to have_content 'Manager'
    end
  end
end
