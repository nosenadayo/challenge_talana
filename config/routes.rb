Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees, only: [:index, :show] do
        get 'availability', on: :member
        collection do
          get 'available_on_date'
        end
      end
    end
  end
end
