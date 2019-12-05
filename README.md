# Ez::Permissions

[![Gem Version](https://badge.fury.io/rb/ez-permissions.svg)](https://badge.fury.io/rb/ez-permissions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/ez-engines/ez-permissions.svg?branch=master)](https://travis-ci.org/ez-engines/ez-permissions)

**Ez Permissions** (read as "easy permissions") - one of the [ez-engines](https://github.com/ez-engines) collection that helps easily add permissions interface to your [Rails](http://rubyonrails.org/) application.

- Most advanced RBAC model:
- Flexible tool with simple DSL and confguration
- All in one solution
- Convetion over configuration principles.
- Depends on [ez-core](https://github.com/ez-engines/ez-core)

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'ez-permissions'
```

## Generators

Generate configuration file:
```bash
rails generate ez:permissions:install
```

### Configuration

Configuration interface allows you to change default behavior
```ruby
Ez::Permissions.configure do |config|
  # If in generated migrations you changed table names, please configure them here:
  config.permission_table_name = 'my_permissions'
  config.roles_table_name = 'my_roles'
  config.models_roles_table_name = 'my_model_roles'
  config.permissions_roles_table_name = 'my_permissions_roles'

  # Suppress stdoud messages for test environment
  config.mute_stdout = true if Rails.env.test?

  # Define your custom callbacks
  config.handle_no_permission_model = lambda { |context|
    raise 'User not exist'
  }

  config.handle_not_authorized = lambda { |context|
    raise 'Not authorized'
  }

  # If you want to use permissions UI capabilities
  require 'ez/permissions/ui'

  # Define your base UI controller
  config.ui_base_controller = 'ApplicationController'

  # Add custom code to Ez::Permissions::RolesController
  config.ui_roles_controller_context = proc do
    before_action :authrozre_user!
  end

  # By default actions ordered by name  as create > read > update > delete
  config.ui_actions_ordering = %w[list create read update delete]

  # Permissions UI ships with default generated CSS classes.
  # You always can inspect them in the browser and override
  config.ui_custom_css_map = {
    'ez-permissions-roles-container' => 'you custom css classes here'
  }
end

```

### UI routes
In your `routes.rb`

```ruby
Rails.application.routes.draw do
  namespace :admin do
    ez_permissions_ui_routes
  end
end
```

### ActiveRecord migrations:

**If you need change table names, please change configuration first**

And run
```bash
rails generate ez:permissions:migrations
```

## DSL

Simple DSL for difinition of permission relationships
```ruby
Ez::Permissions::DSL.define do |setup|
  # You need add all resources of your application and possible actions
  setup.add :roles, actions: %i[create read]

  # Use `crud` for adding default `create`, `read`, `update` and `delete` actions
  # And any your custom action
  setup.add :permissions, actions: %i[crud my_custom_action]

  # Actions option are not required. In such case you add all crud actions by default
  setup.add :users
  setup.add :projects
end
```

## Permission model

In your application, you usually have `User` model.
```ruby
class User < ActiveRecord::Base
  include Ez::Permissions::Model
end

user = User.first

# User model become permission model
user.roles #=> [application level roles]
user.assigned_roles #=> [user owned roles, gloabal and scoped]
user.permissions #=> [user available permissions through assigned_roles]
```

## API

**Please, do not use direct rails code like:** `Ez::Permissions::Permission.create(name: 'admin')`

Instead you should use `Ez::Permissions` public API. Please, extend your custom module with `API` mixin
```ruby
# Use engine facade methods
Ez::Permissions::API

# or extend your own module and keep your code clean
module Permissions
  extend Ez::Permissions::API::Roles
  extend Ez::Permissions::API::Permissions
  extend Ez::Permissions::API::Models
  extend Ez::Permissions::API::Authorize
end
```

### Roles
```ruby
# Create regular role
Permissions.create_role(:user)
Permissions.create_role(:admin)

# List all roles
Permissions.list_roles # => [#<Ez::Permissions::Role..., #<Ez::Permissions::Role...]

# Get role object by name
Permissions.get_role(:user)

# Update role attributes
Permissions.update_role(:user, name: 'super_user')

# Delete role
Permissions.delete_role(:user)

# Assign role to the user
user = User.first
Permissions.assign_role(user, :admin)

# Assign role to the user in scope of any resource
project = Project.first
Permissions.assign_role(user, :admin, scoped: project)

# Reject user role in global scope, but project admin role will stay
Permissions.reject_role(user, :admin)

# Check if user includes global role
Permissions.includes_role?(user, :admin)

# Check if user includes scoped role
project = Project.first
Permissions.includes_role?(user, :manager, scoped: project)
```

### Permissions
```ruby
# Create a role
Permissions.create_role(:user)

# Grant role's possibility to have action per resource
Permissions.grant_permission(:user, :read, :projects)

# Grant all defined actions per resource
Permissions.grant_permission(:user, :all, :projects)

# Revoke particular permission
Permissions.revoke_permission(:user, :create, :projects)
```

### Authorize access
```ruby
user = User.first
project = Project.first

Permissions.create_role(:admin)
Permissions.grant_permission(:admin, :all, :users)
Permissions.assign_role(user, :admin, scoped: project)

Permissions.authorize!(user, :create, :users, scoped: project) do
  # code here would be executed if user has permissions
  # for user creation in particular project
end

# otherwise catch exception
Ez::Permissions::API::Authrozation::NotAuthorized

# if you don't want raise exception, just use
Permissions.authorize(user, :create, :users) { puts 'Yeahh!' } #=> false
# Because user has scoped role in the project and don't has global role.

# and for simple cases you can always ask if user can something
Permissions.can?(user, :create, :users) => # true
Permissions.can?(user, :create, :users, scoped: project) => # false
```

### Testing
EzPermissions ships with bunch of RSpec helper methods that helps mock permission.
For large test suite (more than 5000 specs) it saves up to 30% of test runs time.

Add test helpers tou your rspec config
```ruby
require 'ez/permissions/rspec_helpers'

RSpec.configure do |config|
  config.include Ez::Permissions::RSpecHelpers
end

```

Examples:
```ruby
user = User.first
project = Project.first

# Mock role, model role, all permissions and user assigned role. DB will not be touched.
assume_user_permissions(user, :admin, :all)

# In case when you need real records data to be stored in DB, use
seed_user_permissions(user, :admin, :create, :update, :users, scoped: project)

# Mock role and who possible could has or not this role
mock_role(:manager, has: [user], has_not: [User.second], scoped: project)

# Mock model (user) role assignment
mock_model_role(:worker, user)

# Mock permissions for resources/action
mock_permission(:users, :create)
```

### Kepp it excplicit!
You can wonder, why we just not add authorization methods to user instance, like:
```ruby
user.can?(:something)
```
Because ez-permissions engine don't want pollute your application and keep implementation isolated in external modules.
Of course, you can use them as mixins, but it's up to you.

## Understanding scoped roles
- System have many roles
- User has many assigned roles
- User can has role in scope of some resource (Project, Company, Business, etc.)
- User can has role in global scope (without scope)
- If user want access data in scope of resource - user must has assigned role scoped for this resource
- If user want access data in global scope - user must has assigned role wihtout any scoped resorce (global role)
- User with global role - can't access scoped resources.
- User with scoped role - can't access global resources.

## TODO
- [ ] Add helper methods for seed grant permissions
- [ ] Add rake task `rake ez:permissions:cleanup` to cleanup outdated permissions

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
