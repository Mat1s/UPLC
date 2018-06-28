Rails.application.routes.draw do
	root to: "posts#index"

	resources :posts do 
		member do 
			post :like 
			delete :like
			post :dislike
			delete :dislike
		end
	end

	resources :post_images, only: [:edit, :update]  do
		resources :comments, only: [:new, :create, :index]
		get '/comments/new/(:parent_id)', to: 'comments#new', as: :new_comment
	end
	
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get "/auth/:action/callback", :controller => "authentication", :constraints => { :action => /twitter|facebook/ }
end
