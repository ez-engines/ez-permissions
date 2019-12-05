# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update role' do
  let!(:admin) { Ez::Permissions::Role.create(name: 'admin') }

  scenario 'success' do
    visit '/permissions'

    within('tr#role-admin') do
      click_link 'Edit'
    end

    expect(page).to have_current_path("/permissions/roles/#{admin.id}/edit")

    within '.alert' do
      expect(page).to have_content 'Warning! Changing role name can hurt your application'
    end

    fill_in :role_name, with: 'NewAdmin'

    expect { click_button 'Submit' }.not_to(change { Ez::Permissions::Role.count })

    admin.reload
    expect(admin.name).to eq 'newadmin'
  end

  scenario 'failure' do
    Ez::Permissions::Role.create(name: 'manager')

    visit "/permissions/roles/#{admin.id}/edit"

    # Name must be present
    fill_in :role_name, with: ''

    expect { click_button 'Submit' }.not_to(change { Ez::Permissions::Role.count })

    within '.dummy-form-field' do
      expect(page).to have_content "can't be blank"
    end

    # Name must be unique
    fill_in :role_name, with: 'manager'

    expect { click_button 'Submit' }.not_to(change { Ez::Permissions::Role.count })

    within '.dummy-form-field' do
      expect(page).to have_content 'taken'
    end
  end
end
