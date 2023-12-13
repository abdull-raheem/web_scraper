Rails.application.routes.draw do
  get '/data', to: 'scraper#data'
end
