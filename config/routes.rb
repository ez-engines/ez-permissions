# frozen_string_literal: true

Ez::Permissions::Engine.routes.draw do
  scope module: 'ez/permissions' do
    root to: 'roles#index'

    resources :roles
    resources :permissions, only: :index
  end
end
