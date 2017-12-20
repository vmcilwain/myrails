Rails.application.routes.draw do
  # Requires an application restart everytime a new page is added.
  Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
    action = File.basename(file,'.html.haml')
    get "ui/#{action}", controller: 'ui', action: action
  end
  
  resources :pages
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
