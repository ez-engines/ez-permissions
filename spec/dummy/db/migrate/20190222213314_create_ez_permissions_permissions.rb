# frozen_string_literal: true

class CreateEzPermissionsPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_permissions do |t|
      t.string :resource, index: true, null: false
      t.string :action, index: true, null: false
      t.timestamps null: false
    end
  end
end
