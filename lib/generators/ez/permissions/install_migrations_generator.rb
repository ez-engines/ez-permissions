# frozen_string_literal: true

module Ez
  module Permissions
    class InstallMigrationsGenerator < Rails::Generators::Base
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
      end
    end
  end
end
