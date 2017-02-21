Rails.application.routes.draw do
  get 'home', to: 'pages#home'

  get '/game', to: 'longest_word#game'

  get '/score', to: 'longest_word#score'

end
