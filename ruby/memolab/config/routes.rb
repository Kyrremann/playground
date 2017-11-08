Rails.application.routes.draw do
  root 'welcome#index'

  post 'candidates', to: 'candidate#create'
  resources :candidate, except: [:create]
  
  get 'overview/:candidate_id', to:  'memo#overview', as: :overview_candidate
  post 'overview/note', to:  'memo#new_note', as: :overview_note_new
  get 'overview', to: 'memo#overview'
end
