Rails.application.routes.draw do
  root "weather#index"
  post "weather/show", to: "weather#show", as: :weather_show
  get  'weather/show', to: 'weather#show'
  delete 'weather/clear_cache', to: 'weather#clear_cache'
  delete 'weather/clear_history', to: 'weather#clear_history'
end
