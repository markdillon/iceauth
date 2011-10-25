class IceauthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  def copy_app
    directory "app"
    directory "spec"
    directory "vendor"
  end
  
  def make_routes
    route "root :to => 'pages#home'"
    
    route "match '/signup',  :to => 'users#new'"
    route "match '/signin',  :to => 'sessions#new'"
    route "match '/signout', :to => 'sessions#destroy'"

    route "match '/contact', :to => 'pages#contact'"
    route "match '/about',   :to => 'pages#about'"
    route "match '/help',    :to => 'pages#help'"  
    
    route "resources :sessions, :only => [:new, :create, :destroy]"
    route "resources :users"
  end

end
