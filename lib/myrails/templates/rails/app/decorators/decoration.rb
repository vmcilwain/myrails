class <%= @name.camelize %>Decorator < ApplicationDecorator
  #decorates Namespaced::Model

  # Return concatenated full name
  def name
    <%= @name %>.attribute + " " + <%= @name %>.attribute
  end

  # Return edit path
  def edit_link
    link_to :Edit, edit_<%= @name%>_path(<%= @name %>)
  end
end