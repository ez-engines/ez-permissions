# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update role permissions' do
  let!(:admin)   { Ez::Permissions::API.create_role(:admin) }
  let!(:manager) { Ez::Permissions::API.create_role(:manager) }

  before do
    Ez::Permissions::API.grant_permission(:admin, :all, :projects)
    Ez::Permissions::API.grant_permission(:admin, :all, :users)
  end

  scenario 'success' do
    visit '/permissions'

    within('#role-admin') do
      click_link 'Permissions'
    end

    expect(page).to have_current_path "/permissions/roles/#{admin.id}/permissions"

    within('.notice') do
      expect(page).to have_content 'Permissions controller before action works fine'
    end

    within('.dummy-table-thead-tr') do
      expect(page).to have_content('All')
      expect(page).to have_content('Create')
      expect(page).to have_content('Read')
      expect(page).to have_content('Update')
      expect(page).to have_content('Delete')
      expect(page).to have_content('Custom')
    end

    expect(page).to have_checked_field 'permission-grant-all'

    within('#resource-projects') do
      expect(page).to have_content 'Projects'
      expect(page).to have_checked_field 'permission-checkbox-projects'
      expect(page).to have_checked_field 'permission-checkbox-projects-create'
      expect(page).to have_checked_field 'permission-checkbox-projects-read'
      expect(page).to have_checked_field 'permission-checkbox-projects-update'
      expect(page).to have_checked_field 'permission-checkbox-projects-delete'
      expect(page).to have_checked_field 'permission-checkbox-projects-custom'

      uncheck 'permission-checkbox-projects-create'
      uncheck 'permission-checkbox-projects-read'
      uncheck 'permission-checkbox-projects-update'
      uncheck 'permission-checkbox-projects-delete'
      uncheck 'permission-checkbox-projects-custom'
    end

    within('#resource-users') do
      expect(page).to have_content 'Users'
      expect(page).to have_checked_field 'permission-checkbox-users'
      expect(page).to have_checked_field 'permission-checkbox-users-create'
      expect(page).to have_checked_field 'permission-checkbox-users-read'
      expect(page).not_to have_field 'permission-checkbox-users-update'
      expect(page).not_to have_field 'permission-checkbox-users-delete'
      expect(page).not_to have_field 'permission-checkbox-users-custom'

      uncheck 'permission-checkbox-users-create'
      uncheck 'permission-checkbox-users-read'
    end

    # Uncheck all permissions
    click_button 'Update'

    within('#role-admin') do
      click_link 'Permissions'
    end

    expect(page).to have_unchecked_field 'permission-grant-all'

    within('#resource-projects') do
      expect(page).to have_unchecked_field 'permission-checkbox-projects'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-create'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-read'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-update'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-delete'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-custom'

      check 'permission-checkbox-projects-read'
      check 'permission-checkbox-projects-custom'
    end

    within('#resource-users') do
      expect(page).to have_unchecked_field 'permission-checkbox-users'
      expect(page).to have_unchecked_field 'permission-checkbox-users-create'
      expect(page).to have_unchecked_field 'permission-checkbox-users-read'

      check 'permission-checkbox-users-read'
    end

    # Check only read permissions
    click_button 'Update'

    within('#role-admin') do
      click_link 'Permissions'
    end

    expect(page).to have_unchecked_field 'permission-grant-all'

    within('#resource-projects') do
      expect(page).to have_content 'Projects'
      expect(page).to have_unchecked_field 'permission-checkbox-projects'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-create'
      expect(page).to have_checked_field 'permission-checkbox-projects-read'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-update'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-delete'
      expect(page).to have_checked_field 'permission-checkbox-projects-custom'
    end

    within('#resource-users') do
      expect(page).to have_content 'Users'
      expect(page).to have_unchecked_field 'permission-checkbox-users'
      expect(page).to have_unchecked_field 'permission-checkbox-users-create'
      expect(page).to have_checked_field 'permission-checkbox-users-read'
    end

    # Check manager permissions are empty
    click_button 'Update'

    within('#role-manager') do
      click_link 'Permissions'
    end

    expect(page).to have_current_path "/permissions/roles/#{manager.id}/permissions"

    within('#resource-projects') do
      expect(page).to have_content 'Projects'
      expect(page).to have_unchecked_field 'permission-checkbox-projects'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-create'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-read'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-update'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-delete'
      expect(page).to have_unchecked_field 'permission-checkbox-projects-custom'
    end

    within('#resource-users') do
      expect(page).to have_content 'Users'
      expect(page).to have_unchecked_field 'permission-checkbox-users'
      expect(page).to have_unchecked_field 'permission-checkbox-users-create'
      expect(page).to have_unchecked_field 'permission-checkbox-users-read'
    end
  end
end
