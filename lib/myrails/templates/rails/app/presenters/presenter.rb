# Presenter class for object views
class <%= @name.camelize %>Presenter < BasePresenter
  # Reference initialized object_presenter as object
  presents :<%= @name%>

  # delegate :attribute, to: :<%= @name %>, allow_nil: true

  # Return concatenated full name
  def name
    <%= @name %>.attribute + " " + <%= @name %>.attribute
  end

  # Return edit path
  def edit_link
    link_to :Edit, edit_<%= @name%>_path(<%= @name %>)
  end
end
