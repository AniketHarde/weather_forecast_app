Rails.application.routes.draw do
  root "weather#index"
  post "weather/show", to: "weather#show"
end
