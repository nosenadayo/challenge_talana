  require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create] do
        get :overdue, on: :collection
        get :pending, on: :collection
      end
      resources :employees, only: [:index, :show] do
        get 'availability', on: :member
        collection do
          get 'available_on_date'
        end
      end
      resources :task_assignments, only: [] do
        collection do
          get :report
        end
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
