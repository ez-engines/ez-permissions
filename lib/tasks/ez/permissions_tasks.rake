# frozen_string_literal: true

desc 'List outdated permissions that present in the DB but not using anymore in the DSL'
namespace :ez do
  namespace :permissions do
    task outdated: :environment do
      Ez::Permissions::Permission.find_each do |permission|
        next if Ez::Permissions::DSL.resource_action?(permission.resource, permission.action)

        STDOUT.puts '[WARNING] Ez::Permissions:'\
          "Permission##{permission.id} [#{permission.resource} -> #{permission.action}] is redundant"
      end
    end

    task cleanup: :environment do
      Ez::Permissions::Permission.find_each do |permission|
        next if Ez::Permissions::DSL.resource_action?(permission.resource, permission.action)

        permission.destroy
        STDOUT.puts '[WARNING] Ez::Permissions:'\
          "Permission##{permission.id} [#{permission.resource} -> #{permission.action}] is removed"
      end
    end
  end
end
