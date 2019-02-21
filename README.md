# Ez::Permissions
Short description and motivation.

## Usage
How to use my plugin.

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
```ruby
Ez::Permissions.configure do |config|
  # If in generated migrations you changed table names, please configure them here:
  config.permission_table_name = 'my_permissions'
  config.roles_table_name = 'my_roles'
end
```

## TODO
- [x] Add README
- [x] Add Role model
- [x] Add Permissions model
- [ ] Add PermissionsRole model
- [x] Add rails generators for migrations
- [x] Add rails generators for configuration
- [ ] Add configuration DSL
- [ ] Add permissions helpers like `can?`, `cannot?` and `authorize!`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
