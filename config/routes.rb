MongoMetrics::Engine.routes.draw do
  root to: "metrics#index"
  resources :metrics, only: [:index, :destroy]
end
