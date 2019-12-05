# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create role' do
  let(:created_role) { Ez::Permissions::Role.last }

  scenario 'success' do
    visit '/permissions'

    within '.dummy-add-button-container' do
      click_link 'Add'
    end

    expect(page).to have_current_path '/permissions/roles/new'

    within '.notice'  do
      expect(page).to have_content 'Roles controller before action works fine'
    end

    within '.dummy-form' do
      expect(page).to have_field :role_name
      expect(page).to have_button 'Submit'
      expect(page).to have_link 'Cancel'

      fill_in :role_name, with: 'Admin'

      expect { click_button 'Submit' }.to change { Ez::Permissions::Role.count }.from(0).to(1)

      expect(page).to have_current_path '/permissions'
      expect(created_role.name).to eq 'admin'
    end
  end

  scenario 'failure' do
    Ez::Permissions::Role.create!(name: 'admin')

    visit '/permissions/roles/new'

    # Name must be present
    fill_in :role_name, with: ''

    expect { click_button 'Submit' }.not_to(change { Ez::Permissions::Role.count })

    within '.dummy-form-field' do
      expect(page).to have_content "can't be blank"
    end

    # Name must be unique
    fill_in :role_name, with: 'AdMiN'

    expect { click_button 'Submit' }.not_to(change { Ez::Permissions::Role.count })

    within '.dummy-form-field' do
      expect(page).to have_content 'taken'
    end
  end
end
