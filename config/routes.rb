Rails.application.routes.draw do
  root "blogs#index"

  resource :first_run, only: %i[ show create ]

  resource :session, only: %i[ new create destroy ] do
    scope module: "sessions" do
      resources :transfers, only: %i[ show update ]
    end
  end

  get "join/:join_code", to: "users#new", as: :join
  post "join/:join_code", to: "users#create"

  resource :account do
    scope module: "accounts" do
      resource :join_code, only: :create
      resource :custom_styles, only: %i[ edit update ]
    end
  end

  resources :blogs, except: %i[ index show ] do
    resource :publication, controller: "blogs/publications", only: %i[ show edit update ]
    resource :bookmark, controller: "blogs/bookmarks", only: :show

    scope module: "blogs" do
      namespace :leaves do
        resources :moves, only: :create
      end
    end

    resources :sections
    resources :pictures
    resources :pages
  end

  get "/:id/:slug", to: "blogs#show", constraints: { id: /\d+/ }, as: :slugged_blog
  get "/:blog_id/:blog_slug/:id/:slug", to: "leafables#show", constraints: { blog_id: /\d+/, id: /\d+/ }, as: :slugged_leafable

  direct :blog_slug do |blog, options|
    route_for :slugged_blog, blog, blog.slug, options
  end

  direct :leafable_slug do |leaf, options|
    route_for :slugged_leafable, leaf.blog, leaf.blog.slug, leaf, leaf.slug, options
  end

  resources :pages, only: [] do
    scope module: "pages" do
      resources :edits, only: :show
    end
  end

  resources :qr_code, only: :show
  resources :users do
    scope module: "users" do
      resource :profile
    end
  end

  direct :leafable do |leaf, options|
    route_for "blog_#{leaf.leafable_name}", leaf.blog, leaf, options
  end

  direct :edit_leafable do |leaf, options|
    route_for "edit_blog_#{leaf.leafable_name}", leaf.blog, leaf, options
  end

  namespace :action_text, path: nil do
    get "/u/*slug" => "markdown/uploads#show", as: :markdown_upload
    post "/uploads" => "markdown/uploads#create", as: :markdown_uploads
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
