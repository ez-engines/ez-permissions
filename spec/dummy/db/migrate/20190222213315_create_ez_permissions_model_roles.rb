# frozen_string_literal: true

class CreateEzPermissionsModelRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_model_roles do |t|
      t.integer :model_id, index: true, null: false
      t.string :model_type, index: true, null: false

      t.integer :scoped_id, index: true
      t.string :scoped_type, index: true

      t.integer :role_id, index: true, null: false

      t.timestamps null: false
    end
  end
end
