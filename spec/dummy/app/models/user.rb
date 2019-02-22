# frozen_string_literal: true

class User < ApplicationRecord
  include Ez::Permissions::Model
end
