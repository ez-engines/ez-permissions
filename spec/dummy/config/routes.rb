# frozen_string_literal: true

Rails.application.routes.draw do
  mount Ez::Permissions::Engine => '/ez-permissions'
end
