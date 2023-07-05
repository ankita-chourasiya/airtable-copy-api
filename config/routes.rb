Rails.application.routes.draw do
  get '/copy', to: 'copy#index'
  get '/copy/:key', to: 'copy#show'
  get '/refresh', to: 'copy#refresh'
end
