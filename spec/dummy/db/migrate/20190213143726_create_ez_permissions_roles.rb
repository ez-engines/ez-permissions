# frozen_string_literal: true

class CreateEzPermissionsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_roles do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
