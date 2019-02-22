# frozen_string_literal: true

class CreateEzPermissionsPermissionsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_permissions_roles do |t|
      t.integer :permission_id, index: true, null: false
      t.integer :role_id, index: true
    end
  end
end
