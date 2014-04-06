class AjaxOnlyRequest
  def matches?(request)
    request.xhr?
  end
end

Road::Application.routes.draw do
  resources :special_emails
  
  get '/!/admin', to: 'admin/home#index', as: 'admin'


  # Error pages
  get "/error_404", :to => "errors#error_404"
  get "/error_500", :to => "errors#error_500"

  match '/auth/:provider/callback' => 'authentications#create'

  # These are all AJAX routes
  constraints AjaxOnlyRequest.new do
    get "/library_items", to: "library_items#index", as: "get_library_items"
    post "/library_items", to: "library_items#create"
    get "/library_item", to: "library_items#show"
    put "/library_item", to: "library_items#update"
    delete "/library_item", to: "library_items#delete"
    put "/inbetween", to: "inbetween_places#update"
    get "/inbetween", to: "inbetween_places#show"
  end
  
  resources :authentications

  get '/auth/:provider/callback' => 'authentications#create'
  post '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: "registrations"
  } do
    get "/:username/edit", to: "registrations#edit", as: "edit_user_registration"
  end

  # root to: "users#dashboard"

  # constraints subdomain: 'admin' do
  #   get '/', to: 'admin/home#index', as: 'admin'
  # end

  # namespace :admin, path: 'org' do
  #   resources :events, :module => "organization"
  #     member do
  #       get 'confirm'
  #     end
  #   end
  # end



  get "/home/faq", to: "home#faq", as: "faq"
  get "/trips/top", to: "trips#top", as: "top_trips"
  post "/invites", to: "user_invites#create", as: "user_invite"
  
  get '/', to: "users#dashboard", as: "dashboard"
  # get '/trips', to: "trips#index", as: "trips"
  scope "/:username" do
    get '/', to: "users#show", as: "user"
    get '/following', to: "follows#index", as: "all_following_places"
    get '/follow/new', to: "follows#new", as: "follow_places"
    post '/follow/add', to: "follows#add_places", as: "add_follow_places"
    post '/follow/remove', to: "follows#remove_places", as: "remove_follow_places"
    # get '/follow/recommend', to: "follows#recommend", as: "recommend_follow_places"
    resources :trips do
      get '/publish', to: "trips#publish_trip", as: "publish"
      get '/step-2', to: "trips#add_places", as: "add_places"
      put '/step-2/save', to: "trips#save_added_places", as: "save_added_places"
      get '/step-3/save-as-draft', to: "trips#save_trip_as_draft", as: "save_as_draft"
      get "/share/facebook", to: "trips#share_on_facebook", as: "share_on_facebook"
      # get "/connect/facebook", to: "connect#facebook", as: "connect_facebook"
      post "/like", to: "liked_trips#like", as: "like"
      post "/unlike", to: "liked_trips#unlike", as: "unlike"
      get "/library_items", to: "trips#edit_library_items"
    end
    get "/likes", to: "liked_trips#index", as: "likes"
  end
end

class College
  def initialize(course_name)
    @course = course_name
  end

  def get_students
    "will get students for #{@course}"
  end
end