# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Remove role' do
  let!(:admin) { Ez::Permissions::Role.create(name: 'admin') }

  scenario 'success' do
    visit '/permissions'

    within('tr#role-admin') do
      expect { click_link 'Remove' }.to change { Ez::Permissions::Role.count }.from(1).to(0)
    end

    expect(page).to have_current_path('/permissions')

    within '.alert' do
      expect(page).to have_content 'Role has been successfully removed'
    end

    expect { admin.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
