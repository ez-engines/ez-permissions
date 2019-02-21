# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module Ez
  module Permissions
    class MigrationsGenerator < Rails::Generators::Base
      def create_migration
        create_file "db/migrate/#{Time.current.strftime('%Y%m%d%H%M%S')}_create_ez_permissions_roles.rb",
                    "class CreateEzPermissionsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_roles do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
"
        create_file "db/migrate/#{(Time.current + 1).strftime('%Y%m%d%H%M%S')}_create_ez_permissions_permissions.rb",
                    "class CreateEzPermissionsPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_permissions_permissions do |t|
      t.string :resource, index: true, null: false
      t.string :action, index: true, null: false
      t.timestamps null: false
    end
  end
end
"
      end
    end
  end
end
# rubocop: enable Metrics/MethodLength
