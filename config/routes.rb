Rails.application.routes.draw do
  devise_for(
    :users,
    :path         => "admin",
    :path_names   => {:sign_in => 'login', :sign_out => 'logout'},
    :controllers  => { :sessions => "islay/admin/sessions", :passwords => "islay/admin/passwords" }
  )

  scope :module => 'islay' do
    namespace :admin do
      # DASHBOARD
      get '/' => 'dashboard#index', :as => 'dashboard'

      # USERS
      resources :users do
        get :delete, :on => :member
      end

      # ASSET LIBRARY
      scope :path => 'library' do
        get '/' => 'asset_library#index', :as => 'asset_library'
        get '/browser.json' => 'asset_library#browser', :as => 'browser'

        # Collections and Albums
        resources(:asset_collections, :controller => 'asset_groups', :path => 'collections', :defaults => {:type => 'collection'}) { get :delete, :on => :member }
        resources(:asset_albums,      :controller => 'asset_groups', :path => 'collections/albums', :defaults => {:type => 'album'}) { get :delete, :on => :member }

        # Assets
        asset_resource = lambda do
          collection do
            get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort'
            get :bulk
            post :bulk, :action => 'bulk_create'
          end

          member do
            get :delete
            put :reprocess
          end
        end

        asset_resources = %w(image document video audio)
        asset_resources.each do |s|
          as = "#{s}_assets".to_sym
          resources as, :path => "assets/#{s.pluralize}", :controller => 'assets', :defaults => {:type => as}, &asset_resource
        end

        resources :assets, :defaults => {:type => :assets}, &asset_resource
      end
    end

    # Funky shortcuts for adding assets directly to an album
    get 'admin/library/assets/new/for-album/:asset_album_id' => 'admin/assets#new', :as => 'new_admin_asset_asset_album'
  end
end
