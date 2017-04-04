Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :student_imports do
    collection {post :import}
  end

  # resources :personalized_curriculum

  get '/personalized_curriculums/:student_import_id' => 'personalized_curriculums#show'

  root 'student_imports#new'
end
