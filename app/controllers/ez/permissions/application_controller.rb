# frozen_string_literal: true

module Ez
  module Permissions
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
