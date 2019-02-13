# frozen_string_literal: true

module Ez
  module Permissions
    class Engine < ::Rails::Engine
      isolate_namespace Ez::Permissions
    end
  end
end
