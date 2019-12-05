# frozen_string_literal: true

Ez::Permissions::Engine.routes.draw do
  scope module: 'ez/permissions' do
    root to: 'roles#index'

    resources :roles do
      resources :permissions, only: %i[index create]
    end
  end
end
