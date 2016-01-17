Rails.application.routes.draw do

  get 'checkins/new'
  get 'sessions/new'

  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  # get 'tandc' => 'static_pages#tandc'

  resources :users, only: [:create]
    get 'users/new'
    get 'achiever/settings', to: 'users#edit', :as => :edit_user
    post 'achiever/update', to: 'users#update', :as => :user_update
    get 'achiever', to: "users#show", :as => :user
    # put "/achiever/:permalink", to: "users#update", :as => :user, via: :put
    get '/set_password/:permalink/:activation_code' => "users#set_password", :as => :set_password
    post '/set_password_now/:permalink/:activation_code' => 'users#set_password_attempt', :as => :set_password_attempt

  get    'login'   => 'sessions#new', :as => :login
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # goals
    get 'step1' => 'goals#step1', :as => :step1
    post 'step1_setup' => 'goals#step1_setup', :as => :step1_setup
    get 'step2/:permalink' => 'goals#step2', :as => :step2
    post 'step2_setup/:permalink' => 'goals#step2_setup', :as => :step2_setup
    get 'step3/:permalink' => 'goals#step3', :as => :step3
    post 'step3_setup/:permalink' => 'goals#step3_setup', :as => :step3_setup
    get 'goal/:permalink' => 'goals#show', :as => :goal
    post 'update_goal/:permalink' => 'goals#goal_update', :as => :goal_update
    post 'goal/activate/:permalink' => 'goals#goal_activate', :as => :goal_activate

  # checkins
    get 'checkin' => 'checkins#new', :as => :checkin_new
    post 'checkin/:result' => 'checkins#record_checkin', :as => :record_checkin
    get 'checkin/yes/:permalink' => 'checkins#checkin_yes', :as => :checkin_yes
    get 'checkin/no/:permalink' => 'checkins#checkin_no', :as => :checkin_no
    get 'checkin/big_achievement' => 'checkins#manual_checkin', :as => :manual_checkin
    
end
