# Ez::Permissions

[![Build Status](https://travis-ci.org/ez-engines/ez-permissions.svg?branch=master)](https://travis-ci.org/ez-engines/ez-permissions)

**Ez Permissions** (read as "easy permissions") - one of the [ez-engines](https://github.com/ez-engines) collection that helps easily add permissions interface to your [Rails](http://rubyonrails.org/) application.

- Flexible tool with simple DSL
- Convetion over configuration principles.
- Depends on [ez-core](https://github.com/ez-engines/ez-core)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ez-permissions'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ez-permissions
```

## Generators

Generate configuration file:
```bash
rails generate ez:permissions:install
```

Generate ActiveRecord migrations:
```bash
rails generate ez:permissions:migrations
```

## Configuration

Configuration interface allows you change default behavior:
```ruby
Ez::Permissions.configure do |config|
  # If in generated migrations you changed table names, please configure them here:
  config.permission_table_name = 'my_permissions'
  config.roles_table_name = 'my_roles'
  config.models_roles_table_name = 'my_model_roles'
  config.permissions_roles_table_name = 'my_permissions_roles'
end
```

## DSL

Engine provides for you simple DSL for difinition of permission relationships:
```ruby
Ez::Permissions::DSL.define do |setup|
  # You need add all resources of your application, related data models and possible actions
  setup.add :roles,       model: Ez::Permissions::Role, actions: %i[create read]

  # Use `crud` for adding default `create`, `read`, `update` and `delete` actions
  # And any your custom action
  setup.add :permissions, model: Ez::Permissions::Permission, actions: %i[crud custom]

  # Model and actions options are not required
  # - model will be nil
  # - actions will be only crud
  setup.add :users
  setup.add :projects
end
```

## Permission model

In your application, you should extend the main model with. Usually, it's a `User` model
```ruby
class User < ActiveRecord::Base
  extend Ez::Permissions::Model
end

user = User.first

# User model become permission model
user.roles #=> [relation of application models]
user.model_roles #=> [relation of user roles]
user.permissions #=> [relation of user available permissions through model_roles]
```

## API

**Please, do not use direct rails code like:** `Ez::Permissions::Permission.create(name: 'admin')`

Instead you should use public api. You can extend you custom module with `API` mixin
```ruby
# Use engine facade
Ez::Permissions::API

# or extend your own module and keep anti-corruption layer
module Permissions
  extend Ez::Permissions::API
end
```

### Roles
```ruby
# Create regular role
Permissions.create_role(name: 'user')

# Get role object by name
Permissions.get_role(:user)

# Update role attributes
Permissions.update_role(:user, name: 'super_user')

# Delete role
Permissions.delete_role(:user)
```

### Permissions
```ruby
# Create a role
Permissions.create_role(name: :user)

# Define role's possibility to have actionn with resource
Permissions.grant_permission(:user, :read, :projects)

# or all actions per resource
Permissions.grant_permission(:user, :all, :projects)

# Revoke particular permission
Permissions.revoke_permission(:user, :create, :projects)
```

### Authorize access
`TODO`

## TODO
- [x] Add README
- [x] Add Role model
- [x] Add Permissions model
- [x] Add PermissionsRole model
- [x] Add rails generators for migrations
- [x] Add rails generators for configuration
- [x] Add configuration DSL
- [x] Add Permissions API for managing relationships
- [ ] User can has multiple roles
- [ ] Add permissions helpers like `can?`, `cannot?`, `authorize` and `authorize!`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
