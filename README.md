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
end
```

## Permission model

In your application you should extend main user model with:
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

**Please, do not use direct rails code like: `Ez::Permissions::Permission.create(name: 'admin')`.**

Instead you should use public api. You can extend you custom module with `API` mixin
```ruby
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
`TODO`

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
- [ ] Add Permissions API for managing relationships
- [ ] Add permissions helpers like `can?`, `cannot?`, `authorize` and `authorize!`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
