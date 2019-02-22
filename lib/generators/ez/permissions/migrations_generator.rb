# frozen_string_literal: true

# rubocop:disable all
module Ez
  module Permissions
    class MigrationsGenerator < Rails::Generators::Base
      def config
        Ez::Permissions.config
      end

      def create_migration
        create_file "db/migrate/#{Time.current.strftime('%Y%m%d%H%M%S')}_create_ez_permissions_roles.rb",
                    "# frozen_string_literal: true

class CreateEzPermissionsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :#{config.roles_table_name} do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
"
        create_file "db/migrate/#{(Time.current + 1).strftime('%Y%m%d%H%M%S')}_create_ez_permissions_permissions.rb",
                    "# frozen_string_literal: true

class CreateEzPermissionsPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :#{config.permissions_table_name} do |t|
      t.string :resource, index: true, null: false
      t.string :action, index: true, null: false
      t.timestamps null: false
    end
  end
end
"
        create_file "db/migrate/#{(Time.current + 2).strftime('%Y%m%d%H%M%S')}_create_ez_permissions_model_roles.rb",
                    "# frozen_string_literal: true

class CreateEzPermissionsModelRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :#{config.models_roles_table_name} do |t|
      t.integer :model_id, index: true, null: false
      t.string :model_type, index: true, null: false

      t.integer :scoped_id, index: true
      t.string :scoped_type, index: true

      t.integer :role_id, index: true, null: false

      t.timestamps null: false
    end
  end
end
"

        create_file "db/migrate/#{(Time.current + 3).strftime('%Y%m%d%H%M%S')}_create_ez_permissions_permissions_roles.rb",
                    "# frozen_string_literal: true

class CreateEzPermissionsPermissionsRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :#{config.permissions_roles_table_name} do |t|
      t.integer :permission_id, index: true, null: false
      t.integer :role_id, index: true
    end
  end
end
"
      end
    end
  end
end
# rubocop: enable all
